import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  final controller = AuthController(ref);
  controller.getCurrentUser(); // Immediately fetch user when app starts
  return controller;
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController(this.ref) : super(const AsyncValue.loading());

  final Ref ref;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay
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
      await Future.delayed(const Duration(seconds: 1));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> getCurrentUser() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // Simulate user already logged in or null
      final user = null; // Change to a dummy user if needed
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
