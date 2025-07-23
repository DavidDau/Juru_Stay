import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../controller/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      backgroundColor: const Color.fromARGB(
        255,
        185,
        233,
        255,
      ), // Sky-blue background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Login to your JuruStay account',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder: (context, ref, child) {
                    final authState = ref.watch(authControllerProvider);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          3,
                          80,
                          144,
                        ), // Blue button
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                            },
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(221, 255, 255, 255),
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppConstants.signupRoute),
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: Color.fromARGB(255, 3, 80, 144),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
