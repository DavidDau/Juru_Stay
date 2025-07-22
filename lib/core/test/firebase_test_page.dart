import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestPage extends ConsumerWidget {
  const FirebaseTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firebase Connection Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _testFirebaseAuth(context),
              child: const Text('Test Firebase Auth'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _testFirestore(context),
              child: const Text('Test Firestore'),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => _testConnectivity(context),
              child: const Text('Test Firebase Connectivity'),
            ),
            const SizedBox(height: 20),

            const Text(
              'Results will appear in console/debug output',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testFirebaseAuth(BuildContext context) async {
    try {
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentUser != null
                ? 'Auth: User logged in as ${currentUser.email}'
                : 'Auth: No user logged in',
          ),
        ),
      );

      print('Firebase Auth Test: ${currentUser?.email ?? 'No user'}');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Auth Error: $e')));
      print('Firebase Auth Error: $e');
    }
  }

  Future<void> _testFirestore(BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Try to add a test document
      await firestore.collection('test').add({
        'message': 'Firebase test',
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Try to read from the collection
      final snapshot = await firestore.collection('test').limit(1).get();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firestore: Connected successfully!')),
      );

      print('Firestore Test: Successfully added and retrieved document');
      print('Documents found: ${snapshot.docs.length}');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firestore Error: $e')));
      print('Firestore Error: $e');
    }
  }

  Future<void> _testConnectivity(BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Enable offline persistence
      await firestore.enablePersistence();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firebase: Offline persistence enabled')),
      );

      print('Firebase Connectivity: Offline persistence enabled');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connectivity: $e')));
      print('Firebase Connectivity Error: $e');
    }
  }
}
