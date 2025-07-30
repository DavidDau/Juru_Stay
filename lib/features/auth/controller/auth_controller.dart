import '../model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'package:juru_stay/core/router.dart';


final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  
  AuthController(this.ref) : super(const AsyncValue.loading()) {
    
    // Listen to auth changes
    _setupAuthListener();
  }

  Future<void> _setupAuthListener() async {
  final authStream = ref.read(authServiceProvider).user;

  authStream.listen((user) {
    state = AsyncValue.data(user);
  });
}

// Move this outside
void _navigateBasedOnRole(String role) {
  final router = ref.read(routerProvider);
  if (role == 'commissioner') {
    router.go('/commissioner/dashboard');
  } else if (role == 'tourist') {
    router.go('/places');
  } else {
    router.go('/home');
  }
}


  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phone,
    String? bio,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        phone: phone,
        bio: bio,
      );
      if (user == null) throw Exception('Sign up failed');
state = AsyncValue.data(user);
final userRole = await _authService.getUserRole(user.uid);
_navigateBasedOnRole(userRole);

    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithEmail(email, password);
      if (user == null) throw Exception('Invalid credentials');
state = AsyncValue.data(user);
final role = await _authService.getUserRole(user.uid);
_navigateBasedOnRole(role);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
  state = const AsyncValue.loading();
  try {
    final user = await _authService.signInWithGoogle();
    if (user == null) throw Exception('Google sign in failed');
    state = AsyncValue.data(user);

    // Get role and navigate
    final userRole = await _authService.getUserRole(user.uid);
    _navigateBasedOnRole(userRole);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
    rethrow;
  }
}


  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
