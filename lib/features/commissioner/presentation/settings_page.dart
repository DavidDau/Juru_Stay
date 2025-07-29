import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<bool>((ref) => false);
 // false = light, true = dark

class CommissionerSettingsPage extends ConsumerWidget {
  const CommissionerSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'User Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Theme toggle
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) => ref.read(themeModeProvider.notifier).state = value,
          ),

          const Divider(height: 32),

          // Edit profile placeholder
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile Info'),
            onTap: () {
              context.push('/commissioner/profile');
            },
          ),

          const Divider(height: 32),

          // Terms & Conditions
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('View Terms & Conditions'),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Terms & Conditions"),
                  content: const SingleChildScrollView(
                    child: Text("These are placeholder terms and conditions..."),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Close"),
                    )
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          const Divider(),
          // Logout or delete option
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Handle deletion here (optional)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Delete feature not yet implemented")),
              );
            },
          ),
        ],
      ),
    );
  }
}
