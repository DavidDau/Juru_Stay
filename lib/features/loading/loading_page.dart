import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      context.go('/login'); // Force redirect after delay
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}