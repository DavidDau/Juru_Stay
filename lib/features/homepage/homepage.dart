import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> allTours = [
    {
      'title': 'City Sightseeing',
      'subtitle': 'Explore the city\'s landmarks',
      'icon': Icons.flight,
    },
    {
      'title': 'Accomodation Tour',
      'subtitle': 'Discover hidden gems',
      'icon': Icons.pedal_bike,
    },
    {
      'title': 'Hotels Experience',
      'subtitle': 'Taste local flavors',
      'icon': Icons.restaurant,
    },
  ];

  int selectedIndex = 0;

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
            _buildDrawerItem(Icons.description, 'Terms', () => context.go('/terms')),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Explore our Tours", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...allTours.map((tour) => ListTile(
                          leading: Icon(tour['icon'], size: 30),
                          title: Text(tour['title']),
                          subtitle: Text(tour['subtitle']),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "JURUSTAY THE BEST\nADVENTURE EXPERIENCE.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Accommodation Inspirations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildInspirationsStream(),
            ],
          ),
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

  Widget _buildInspirationsStream() {
    return SizedBox(
      height: 260,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data!.docs;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final data = results[index].data() as Map<String, dynamic>;
              final imageUrl = data['imageUrl'] ?? '';
              final name = data['name'] ?? 'Unnamed';
              final location = data['location'] ?? 'Unknown';
              final price = data['price'] ?? 0;

              return Container(
                width: 250,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("📍 $location"),
                    const SizedBox(height: 4),
                    Text("💵 RWF $price"),
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
