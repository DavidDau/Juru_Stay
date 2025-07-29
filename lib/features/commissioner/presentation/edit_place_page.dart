import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPlacePage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditPlacePage({required this.docId, required this.data, Key? key}) : super(key: key);

  @override
  State<EditPlacePage> createState() => _EditPlacePageState();
}

class _EditPlacePageState extends State<EditPlacePage> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController contactController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.data['name']);
    locationController = TextEditingController(text: widget.data['location']);
    priceController = TextEditingController(text: widget.data['price'].toString());
    descriptionController = TextEditingController(text: widget.data['description']);
    contactController = TextEditingController(text: widget.data['contact']);
  }

  void updatePlace() async {
    await FirebaseFirestore.instance.collection('places').doc(widget.docId).update({
      'name': nameController.text,
      'location': locationController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descriptionController.text,
      'contact': contactController.text,
    });
    Navigator.pop(context); // Return to dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Place")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price")),
            TextField(controller: contactController, decoration: const InputDecoration(labelText: "Contact")),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updatePlace, child: const Text("Update"))
          ],
        ),
      ),
    );
  }
}
