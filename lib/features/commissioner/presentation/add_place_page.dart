import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitForm() async {

    final userId = FirebaseAuth.instance.currentUser?.uid;

final placeData = {
  'name': nameController.text.trim(),
  'description': descriptionController.text.trim(),
  'price': double.tryParse(priceController.text.trim()) ?? 0.0,
  'location': locationController.text.trim(),
  'contact': contactController.text.trim(),
  'imageUrl': imageUrlController.text.trim(),
  'createdAt': Timestamp.now(),
  'commissionerId': userId, // 🔥 important
};

  

    try {
      await FirebaseFirestore.instance.collection('places').add(placeData);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place added successfully!')),
      );
      Navigator.pop(context); // Go back after success
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error saving place: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add place')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image preview if URL is valid
              imageUrlController.text.trim().isNotEmpty
                  ? Image.network(imageUrlController.text.trim(), height: 180, fit: BoxFit.cover)
                  : Container(
                      height: 180,
                      color: Colors.blue[50],
                      child: const Center(
                        child: Text('Image preview will appear here', style: TextStyle(color: Colors.blue)),
                      ),
                    ),
              const SizedBox(height: 20),

              _buildTextField('Image URL', imageUrlController, keyboardType: TextInputType.url),
              const SizedBox(height: 12),

              _buildTextField('Name', nameController),
              const SizedBox(height: 12),

              _buildTextField('Description', descriptionController, maxLines: 3),
              const SizedBox(height: 12),

              _buildTextField('Price (RWF)', priceController, keyboardType: TextInputType.number),
              const SizedBox(height: 12),

              _buildTextField('Location', locationController),
              const SizedBox(height: 12),

              _buildTextField('Contact Number', contactController, keyboardType: TextInputType.phone),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: const Icon(Icons.check),
                label: Text(_isLoading ? 'Submitting...' : 'Submit'),
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
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
      onChanged: (_) {
        if (label == 'Image URL') setState(() {});
      },
      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
    );
  }
}
