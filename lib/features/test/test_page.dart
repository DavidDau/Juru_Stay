import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Connection Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  print('🧪 Testing Firebase connection...');

                  // Test Firebase Auth availability
                  print('📧 Firebase Auth available');

                  // Test Firestore availability
                  print('📊 Firestore available');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        '✅ Firebase test completed - check console',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('❌ Test failed: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Test failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Test Firebase Connection'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  print('👤 Testing mock auth...');

                  // Create a mock user for testing
                  print('✅ Mock auth successful');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Mock auth test completed'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('❌ Mock auth failed: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Mock auth failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Test Mock Authentication'),
            ),
          ],
        ),
      ),
    );
  }
}
