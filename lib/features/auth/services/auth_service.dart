import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream of user changes
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _getUserData(firebaseUser.uid);
    });
  }

  // Get user data from Firestore
  Future<UserModel?> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  // Email & Password Sign Up
  Future<UserModel?> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phone,
    String? bio,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        phone: phone,
        bio: bio,
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      return user;
    } catch (e) {
      print('SignUp Error: $e');
      return null;
    }
  }

  // Email & Password Sign In
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getUserData(userCredential.user!.uid);
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  // Google Sign In
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;
      //restpassword
      // Check if user exists in Firestore
      Future<void> sendPasswordResetEmail(String email) async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }

      // Check if user exists in Firestore
      var userData = await _getUserData(user.uid);

      // If new user, create document
      if (userData == null) {
        final names = user.displayName?.split(' ') ?? ['', ''];
        userData = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          firstName: names.first,
          lastName: names.length > 1 ? names.last : '',
          role: 'tourist', // Default role
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userData.toMap());
      }

      return userData;
    } catch (e) {
      print('Google SignIn Error: $e');
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();
      return data?['role'] ?? 'unknown';
    } catch (e) {
      print('GetUserRole Error: $e');
      return 'unknown';
    }
  }

  // delete account
  Future<void> deleteCommissionerProfile(String uid) async {
    try {
      // Delete from Firestore
      await _firestore.collection('commissioners').doc(uid).delete();

      // Try deleting the auth user
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No authenticated user found.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // This means the user needs to reauthenticate before deletion
        throw Exception('Please re-authenticate to delete your account.');
      } else {
        throw Exception('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
