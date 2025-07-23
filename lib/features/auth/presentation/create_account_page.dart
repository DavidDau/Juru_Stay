import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants.dart';
import '../controller/auth_controller.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? selectedRole;
  final List<String> roles = ['Tourist', 'Commissioner'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Sky blue
              Color(0xFFE0F6FF), // Very light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // First Name Field
                    _buildTextField(
                      controller: firstNameController,
                      hint: 'First Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),

                    // Last Name Field
                    _buildTextField(
                      controller: lastNameController,
                      hint: 'Last Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller: emailController,
                      hint: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Role Dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedRole,
                        hint: const Row(
                          children: [
                            Icon(Icons.work, color: Colors.grey),
                            SizedBox(width: 12),
                            Text('Select Role'),
                          ],
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        items: roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    _buildTextField(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    _buildTextField(
                      controller: confirmPasswordController,
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _signup() {
    // Validation
    if (firstNameController.text.trim().isEmpty) {
      _showError('Please enter your first name');
      return;
    }
    if (lastNameController.text.trim().isEmpty) {
      _showError('Please enter your last name');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!emailController.text.trim().contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (selectedRole == null) {
      _showError('Please select a role');
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      _showError('Please enter a password');
      return;
    }
    if (passwordController.text.trim().length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _showError('Passwords do not match');
      return;
    }

    // Combine first and last name
    final fullName =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}';

    // Call the signup function
    ref
        .read(authControllerProvider.notifier)
        .signup(
          fullName,
          emailController.text.trim(),
          passwordController.text.trim(),
        );

    // Show success message and redirect to login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to login page
    context.go('/login');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
