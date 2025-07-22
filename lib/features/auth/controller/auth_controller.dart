import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
      return AuthController(ref);
    });

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement login logic
      // For now, we'll just simulate a login
      await Future.delayed(const Duration(seconds: 1));
      final user = UserModel(
        id: '1',
        email: email,
        name: 'Test User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement signup logic
      // For now, we'll just simulate a signup
      await Future.delayed(const Duration(seconds: 1));
      final user = UserModel(
        id: '1',
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement logout logic
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement get current user logic
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
