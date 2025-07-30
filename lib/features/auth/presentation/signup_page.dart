import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/rounded_button.dart';
import '../controller/auth_controller.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  String _selectedRole = 'tourist';
  bool _isCommissioner = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            role: _selectedRole,
            phone: _isCommissioner ? _phoneController.text.trim() : null,
            bio: _isCommissioner ? _bioController.text.trim() : null,
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF4285F4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Role Selection
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Tourist'),
                      leading: Radio<String>(
                        value: 'tourist',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                            _isCommissioner = false;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Commissioner'),
                      leading: Radio<String>(
                        value: 'commissioner',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                            _isCommissioner = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Personal Info
              AuthTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your first name' : null,
              ),
              const SizedBox(height: 15),
              AuthTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your last name' : null,
              ),
              const SizedBox(height: 15),
              AuthTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 15),
              AuthTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 15),
              AuthTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              // Commissioner Fields
              if (_isCommissioner) ...[
                const SizedBox(height: 20),
                AuthTextField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 15),
                AuthTextField(
                  controller: _bioController,
                  labelText: 'Bio',
                  keyboardType: TextInputType.multiline,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your bio' : null,
                ),
              ],

              const SizedBox(height: 30),
              RoundedButton(
                text: 'Sign Up',
                onPressed: _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}