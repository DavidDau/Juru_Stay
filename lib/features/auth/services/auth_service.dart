import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get current user
  static User? get currentUser => _auth.currentUser;

  /// Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

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
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return await getUserData(userCredential.user!.uid);
      }
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
    return null;
  }

  /// Get user data from Firestore
  static Future<UserModel?> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        return UserModel.fromJson({'id': uid, ...userData});
      }
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
    return null;
  }

  /// Update user data
  static Future<UserModel?> updateUserData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      final updateData = {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('users').doc(uid).update(updateData);
      return await getUserData(uid);
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
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
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete user account
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  /// Listen to auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}
