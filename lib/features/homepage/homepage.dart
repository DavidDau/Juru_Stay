import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../features/places/presentation/places_page.dart';
import '../../features/commissioner/presentation/terms_page.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/feedbacks/presentation/feedbacks_page.dart';
import '../../features/auth/presentation/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final List<Map<String, dynamic>> allTours = [
    {
      'title': 'City Sightseeing',
      'subtitle': 'Explore the city\'s landmarks',
      'price': '\$25',
      'icon': Icons.flight,
    },
    {
      'title': 'Accomodation Tour',
      'subtitle': 'Discover hidden gems',
      'price': '\$45',
      'icon': Icons.pedal_bike,
    },
    {
      'title': 'Hotels Experience',
      'subtitle': 'Taste local flavors',
      'price': '\$60',
      'icon': Icons.restaurant,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTours = allTours.where((tour) {
      final q = searchQuery.toLowerCase();
      return tour['title'].toLowerCase().contains(q) ||
          tour['subtitle'].toLowerCase().contains(q) ||
          tour['price'].toLowerCase().contains(q);
    }).toList();

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
            _buildDrawerItem(Icons.home, 'Home', () {
              Navigator.pop(context);
            }),
            _buildDrawerItem(Icons.photo_album, 'Gallery', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PlacesPage()));
            }),
            _buildDrawerItem(Icons.description, 'Terms', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsPage()));
            }),
            // _buildDrawerItem(Icons.dark_mode, 'Mode', () {
            //   // Toggle mode logic can be added here.
            // }),
            _buildDrawerItem(Icons.feedback, 'Feedbacks', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbacksPage()));
            }),
            _buildDrawerItem(Icons.logout, 'Logout', () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            }),
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
                    hintText: 'Search for your next adventure',
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                    const Text("Top Rated Tours", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...filteredTours.map((tour) => ListTile(
                          leading: Icon(tour['icon'], size: 30),
                          title: Text(tour['title']),
                          subtitle: Text(tour['subtitle']),
                          trailing: Text(tour['price'], style: const TextStyle(fontWeight: FontWeight.bold)),
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

          final results = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final imageUrl = data['imageUrl'] ?? '';
            final name = data['name']?.toString().toLowerCase() ?? '';
            final location = data['location']?.toString().toLowerCase() ?? '';
            final q = searchQuery.toLowerCase();

            final validImage = imageUrl.toString().isNotEmpty &&
                (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

            return validImage && (name.contains(q) || location.contains(q));
          }).toList();

          if (results.isEmpty) {
            return const Center(child: Text("No matching inspirations found."));
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final data = results[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unnamed';
              final location = data['location'] ?? 'Unknown';
              final price = data['price'] ?? 0;
              final imageUrl = data['imageUrl'] ?? '';

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
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
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

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }
}
