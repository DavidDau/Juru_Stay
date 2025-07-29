import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:juru_stay/features/auth/model/user_model.dart';
import 'package:juru_stay/features/commissioner/presentation/edit_place_page.dart';
class CommissionerDashboardPage extends StatelessWidget {
  final UserModel user;

  const CommissionerDashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String firstLetter = user.firstName.isNotEmpty
        ? user.firstName[0].toUpperCase()
        : '?';

    final userUid = user.uid; // Use from your UserModel

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
              onTap: () {
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/');
                        },
                      ),
                    ],
                  ),
                );
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
                Text(
                  user.bio!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 8),
              if (user.phone != null)
                Text(
                  'Phone: ${user.phone!}',
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 24),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
  .collection('places') // 🔄 changed from 'accommodations'
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
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    var doc = snapshot.data!.docs[index];
    var data = doc.data() as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(data['name'] ?? ''),
        subtitle: Text("Location: ${data['location'] ?? ''}\nPrice: ${data['price'] ?? ''}"),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPlacePage(docId: doc.id, data: data),
                ),
              );
            } else if (value == 'delete') {
              FirebaseFirestore.instance.collection('places').doc(doc.id).delete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () {
          // You can show a full page or dialog to view details
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
                  Image.network(data['imageUrl'] ?? ''),
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
