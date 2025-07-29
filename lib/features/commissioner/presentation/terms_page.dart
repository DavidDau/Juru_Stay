import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Agreements'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              '1. Introduction',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Welcome to our app. By using this platform, you agree to follow the rules outlined below.\n',
            ),
            Text(
              '2. Use of Service',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'You may use this app to explore and manage adventure listings.\nMisuse or fraudulent use is not allowed.\n',
            ),
            Text(
              '3. User Accounts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'You are responsible for the safety of your account. Don’t share your login details with others.\n',
            ),
            Text(
              '4. Agent & Commissioner Roles',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '• Agents can add adventure places.\n• Commissioners manage and approve listings.\nRespect others\' roles and only use features assigned to your role.\n',
            ),
            Text(
              '5. Listings & Content',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Only share accurate, real, and respectful content. We reserve the right to remove inappropriate or fake listings.\n',
            ),
            Text(
              '6. Contact & Communication',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Users may contact agents through the app. Use polite, legal communication at all times.\n',
            ),
            Text(
              '7. Changes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We may update these terms occasionally. You’ll be notified in-app.\n',
            ),
            Text(
              '8. Termination',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We can suspend or remove accounts that break the rules.\n',
            ),
            Text(
              '9. Contact Us',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Questions? Reach out to us via the app’s contact section.\n',
            ),
          ],
        ),
      ),
    );
  }
}
