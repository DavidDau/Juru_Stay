import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  File? _selectedImage;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> uploadPlace() async {
    if (_selectedImage == null ||
        nameController.text.isEmpty ||
        locationController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all required fields and pick an image.")),
      );
      return;
    }

    final fileName = path.basename(_selectedImage!.path);
    final ref = _storage.ref().child('places_images/$fileName');
    await ref.putFile(_selectedImage!);
    final downloadUrl = await ref.getDownloadURL();

    await _firestore.collection('places').add({
      'name': nameController.text,
      'location': locationController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descriptionController.text,
      'imageUrl': downloadUrl,
      'createdAt': Timestamp.now(),
    });

    Navigator.pop(context); // close dialog
    setState(() {}); // refresh page
  }

  void showAddPlaceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Place'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              if (_selectedImage != null) Text("✅ Image selected"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: uploadPlace, child: const Text("Upload")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Places"),
        backgroundColor: Colors.blueGrey[100],
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('places').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No places found."));
          }

          final places = snapshot.data!.docs;

          return ListView.builder(
            itemCount: places.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final data = places[index].data() as Map<String, dynamic>;

              final name = data['name'] ?? 'Unnamed Place';
              final location = data['location'] ?? 'Unknown location';
              final imageUrl = data['imageUrl'] ?? '';
              final price = data['price'] ?? 0;
              final description = data['description'] ?? 'No description available.';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: Text("🚫 Image not available")),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("📍 $location", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text(description, maxLines: 3, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Text("💵 Price: RWF $price", style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddPlaceDialog,
        backgroundColor: Colors.black87,
        child: const Icon(Icons.add),
      ),
    );
  }
}
