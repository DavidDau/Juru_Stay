import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import '../services/auth_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
      // Don't automatically check current user to prevent initialization issues
      return AuthController(ref);
    });

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await AuthService.signIn(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await AuthService.signUp(
        name: name,
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await AuthService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getCurrentUser() async {
    try {
      print('👤 Checking current user...');
      final currentUser = AuthService.currentUser;
      if (currentUser != null) {
        print('✅ Current user found: ${currentUser.email}');
        final user = await AuthService.getUserData(currentUser.uid);
        state = AsyncValue.data(user);
      } else {
        print('ℹ️ No current user found');
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      print('❌ Get current user error: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser != null) {
        final user = await AuthService.updateUserData(
          uid: currentUser.uid,
          data: data,
        );
        state = AsyncValue.data(user);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
