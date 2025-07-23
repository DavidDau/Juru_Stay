import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../controller/auth_controller.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    ref.listen(authControllerProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            context.go(AppConstants.homeRoute);
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: AppConstants.defaultPadding * 2),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(authControllerProvider.notifier)
                    .signup(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                    );
              },
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () => context.go(AppConstants.loginRoute),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
