import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              final contact = data['contact'] ?? 'No contact provided';

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
                          const SizedBox(height: 6),
                          Text("📞 Contact: $contact", style: const TextStyle(color: Colors.blueGrey)),
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
    );
  }
}
