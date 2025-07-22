import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../auth/controller/auth_controller.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await ref.read(authControllerProvider.notifier).getCurrentUser();
    if (!mounted) return;

    final authState = ref.read(authControllerProvider);
    authState.whenOrNull(
      data: (user) {
        if (user != null) {
          context.go(AppConstants.homeRoute);
        } else {
          context.go(AppConstants.loginRoute);
        }
      },
      error: (_, __) => context.go(AppConstants.loginRoute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
