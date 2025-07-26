import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../../core/services/firestore_service.dart';
import 'package:juru_stay/core/services/firestore_service.dart' as firestore;
// import 'package:juru_stay/core/services/commissioner_service.dart';


class EditCommissionerProfilePage extends StatefulWidget {
  const EditCommissionerProfilePage({super.key});

  @override
  State<EditCommissionerProfilePage> createState() =>
      _EditCommissionerProfilePageState();
}

class _EditCommissionerProfilePageState
    extends State<EditCommissionerProfilePage> {
  final TextEditingController nameController = TextEditingController(
    text: 'Commissioner John',
  );
  final TextEditingController bioController = TextEditingController(
    text: 'Experienced local tour guide.',
  );
  final TextEditingController contactController = TextEditingController(
    text: '+254712345678',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile picture section
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/profile.jpg',
                    ), // Replace with dynamic image
                    backgroundColor: Colors.blue,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // Implement image picker
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name
            _buildTextField(label: 'Full Name', controller: nameController),
            const SizedBox(height: 16),

            // Bio
            _buildTextField(
              label: 'Bio',
              controller: bioController,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Contact Info
            _buildTextField(
              label: 'Contact Number',
              controller: contactController,
            ),
            const SizedBox(height: 24),

            // Save button
            ElevatedButton.icon(
              onPressed: () async {
                final firestoreService = firestore.FirestoreService();
                try {
                  await firestoreService.updateCommissionerProfile(
                    name: nameController.text.trim(),
                    bio: bioController.text.trim(),
                    contact: contactController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              // Save to Firestore or local storag
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
