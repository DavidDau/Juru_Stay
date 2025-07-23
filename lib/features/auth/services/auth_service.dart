import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';
import '../../../core/constants.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  /// Retry helper with exponential backoff
  static Future<T> _retryWithBackoff<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    int attempts = 0;
    int delay = AppConstants.retryDelaySeconds;

    while (attempts < AppConstants.maxRetryAttempts) {
      try {
        attempts++;
        print(
          '🔄 Attempting $operationName (attempt $attempts/${AppConstants.maxRetryAttempts})',
        );
        return await operation();
      } catch (e) {
        print('❌ Attempt $attempts failed: $e');

        // Check if this is a Firebase permission/API error
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('permission_denied') ||
            errorStr.contains('api has not been used') ||
            errorStr.contains('unavailable')) {
          if (attempts >= AppConstants.maxRetryAttempts) {
            if (errorStr.contains('api has not been used')) {
              throw Exception(
                'Firestore API is not enabled. Please enable it at: '
                'https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=jurustay-app',
              );
            }
            rethrow;
          }

          print('⏳ Waiting ${delay}s before retry...');
          await Future.delayed(Duration(seconds: delay));

          // Exponential backoff with max cap
          delay = (delay * 2).clamp(1, AppConstants.maxRetryDelaySeconds);
        } else {
          // For non-retryable errors, fail immediately
          rethrow;
        }
      }
    }

    throw Exception(
      'Operation failed after ${AppConstants.maxRetryAttempts} attempts',
    );
  }

  /// Sign up with email and password
  static Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return await _retryWithBackoff<UserModel?>(() async {
          final userData = {
            'email': email,
            'name': name,
            'phone_number': null,
            'profile_image': null,
            'is_commissioner': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userData);

          return UserModel.fromJson({
            'id': userCredential.user!.uid,
            ...userData,
          });
        }, 'Firestore signUp userData creation');
      }
    } catch (e) {
      throw Exception('Failed to sign up: ${e.toString()}');
    }
    return null;
  }

  /// Sign in with email and password
  static Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Attempting to sign in with email: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase Auth successful: ${userCredential.user?.uid}');

      if (userCredential.user != null) {
        print('📊 Fetching user data from Firestore...');
        final userData = await getUserData(userCredential.user!.uid);
        print('✅ User data retrieved: ${userData?.name}');
        return userData;
      }
    } catch (e) {
      print('❌ Sign in error: $e');
      throw Exception('Failed to sign in: ${e.toString()}');
    }
    return null;
  }

  /// Get user data from Firestore
  static Future<UserModel?> getUserData(String uid) async {
    return await _retryWithBackoff<UserModel?>(() async {
      try {
        print('📊 Fetching user document for UID: $uid');
        final userDoc = await _firestore.collection('users').doc(uid).get();

        print('📄 Document exists: ${userDoc.exists}');
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          print('📋 User data: $userData');
          return UserModel.fromJson({'id': uid, ...userData});
        } else {
          print('⚠️ User document not found in Firestore');
          return null;
        }
      } catch (e) {
        print('❌ Firestore error: $e');
        throw e; // Re-throw to let retry mechanism handle it
      }
    }, 'Firestore getUserData');
  }

  /// Update user data
  static Future<UserModel?> updateUserData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    return await _retryWithBackoff<UserModel?>(() async {
      final updateData = {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('users').doc(uid).update(updateData);
      return await getUserData(uid);
    }, 'Firestore updateUserData');
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  /// Delete user account
  static Future<void> deleteAccount() async {
    return await _retryWithBackoff<void>(() async {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user account
        await user.delete();
      }
    }, 'deleteAccount');
  }

  /// Listen to auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}
