import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juru_stay/features/auth/model/user_model.dart';
import 'package:juru_stay/features/commissioner/presentation/edit_place_page.dart';
import 'package:juru_stay/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommissionerDashboardPage extends StatelessWidget {
  final UserModel user;

  const CommissionerDashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String firstLetter =
        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?';
    final userUid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commissioner Dashboard'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      firstLetter,
                      style: const TextStyle(fontSize: 24, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () => context.push('/edit-commissioner-profile', extra: user),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => context.push('/commissioner/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms & Conditions'),
              onTap: () => context.push('/terms'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => context.go('/'),
            ),
            ListTile(
  leading: const Icon(Icons.delete, color: Colors.red),
  title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
  onTap: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final container = ProviderScope.containerOf(context, listen: false);
          final authService = container.read(authServiceProvider);
          await authService.deleteCommissionerProfile(user.uid);
          context.go('/login');
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $e')),
          );
        }
      }
    }
  },
),



          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user.firstName}!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (user.bio != null && user.bio!.isNotEmpty)
                Text(user.bio!, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              if (user.phone != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Phone: ${user.phone!}', style: const TextStyle(fontSize: 16)),
                ),
              const SizedBox(height: 24),

              // Cards for actions
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blue[50],
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => context.push('/add-place'),
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(Icons.add_home_work, size: 40, color: Colors.blue),
                              SizedBox(height: 10),
                              Text('Submit New Accommodation', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      color: Colors.green[50],
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => context.push('/commissioner/places'),
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(Icons.bar_chart, size: 40, color: Colors.green),
                              SizedBox(height: 10),
                              Text('Track Earnings', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Text(
                'Your Listings:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('places')
                    .where('commissionerId', isEqualTo: userUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No accommodations found.');
                  }

                  final accommodations = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: accommodations.length,
                    itemBuilder: (context, index) {
                      final doc = accommodations[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(data['name'] ?? 'No name'),
                          subtitle: Text("Location: ${data['location'] ?? ''}\nPrice: ${data['price'] ?? ''}"),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPlacePage(docId: doc.id, data: data),
                                  ),
                                );
                              } else if (value == 'delete') {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Listing'),
                                    content: const Text('Are you sure you want to delete this accommodation?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () => Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        onPressed: () => Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('places')
                                      .doc(doc.id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Deleted successfully')),
                                  );
                                }
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(data['name'] ?? ''),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Location: ${data['location'] ?? ''}"),
                                    Text("Price: ${data['price'] ?? ''}"),
                                    Text("Description: ${data['description'] ?? ''}"),
                                    const SizedBox(height: 10),
                                    if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(data['imageUrl'], height: 150),
                                      )
                                    else
                                      const Text("No image provided"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
