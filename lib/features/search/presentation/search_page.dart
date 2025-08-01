import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/services/auth_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  int selectedIndex = 1; // ✅ Set default to Search

  void _onItemTapped(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/feedbacks');
        break;
      case 3:
        context.go('/terms');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0C4D8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'JuruStay',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            _buildDrawerItem(Icons.home, 'Home', () => context.go('/home')),
            _buildDrawerItem(Icons.photo_album, 'Gallery', () => context.go('/search')),
            _buildDrawerItem(Icons.description, 'Terms', () => context.go('//commissioner/settings')),
            _buildDrawerItem(Icons.feedback, 'Feedbacks', () => context.go('/feedbacks')),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black87),
              title: const Text('Logout', style: TextStyle(fontSize: 14)),
              onTap: () async {
                await AuthService().signOut();
                if (context.mounted) context.go('/');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: 'Search by name, location, or price',
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('places')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No places found."));
                  }

                  final places = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final query = searchQuery.toLowerCase();
                    return (data['name'] ?? '').toLowerCase().contains(query) ||
                        (data['location'] ?? '').toLowerCase().contains(query) ||
                        (data['price']?.toString() ?? '').contains(query);
                  }).toList();

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
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFFB0C4D8),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }
}
