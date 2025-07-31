import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:juru_stay/features/auth/model/user_model.dart';
import 'package:juru_stay/features/commissioner/presentation/edit_place_page.dart';
import 'package:juru_stay/features/commissioner/presentation/controllers/dashboard_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Make sure this is imported
class CommissionerDashboardPage extends ConsumerWidget {
  final UserModel user;

  const CommissionerDashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String firstLetter =
        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?';
    final placesStream = ref.watch(commissionerPlacesStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commissioner Dashboard'),
        backgroundColor: Colors.blue,
      ),
      drawer: _buildDrawer(context, ref, firstLetter),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(),
              const SizedBox(height: 24),
              _buildActionCards(context),
              const SizedBox(height: 24),
              const Text(
                'Your Listings:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPlacesList(context, ref, placesStream),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, WidgetRef ref, String firstLetter) {
    return Drawer(
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
            onTap: () => context.push('/commissioner/terms'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () => _showDeleteAccountDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog(BuildContext context, WidgetRef ref) async {
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
      final controller = ref.read(commissionerDashboardControllerProvider.notifier);
      try {
        await controller.deleteAccount(user.uid);
        if (context.mounted) context.go('/login');
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $e')),
          );
        }
      }
    }
  }

  Widget _buildUserInfo() {
    return Column(
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
      ],
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildPlacesList(BuildContext context, WidgetRef ref, AsyncValue<QuerySnapshot> placesStream) {
  return placesStream.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, stack) => Text('Error: $error'),
    data: (snapshot) {
      if (snapshot.docs.isEmpty) {  // Check docs.isEmpty instead of size
        return const Text('No accommodations found.');
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.docs.length,  // Use docs.length
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          final data = doc.data() as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(data['name'] ?? 'No name'),
              subtitle: Text("Location: ${data['location'] ?? ''}\nPrice: ${data['price'] ?? ''}"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) => _handlePlaceAction(context, ref, value, doc),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
              onTap: () => _showPlaceDetails(context, data),
            ),
          );
        },
      );
    },
  );
}
  Future<void> _handlePlaceAction(BuildContext context, WidgetRef ref, String value, QueryDocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
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
        final controller = ref.read(commissionerDashboardControllerProvider.notifier);
        try {
          await controller.deletePlace(doc.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deleted successfully')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error deleting place: $e')),
            );
          }
        }
      }
    }
  }

  void _showPlaceDetails(BuildContext context, Map<String, dynamic> data) {
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
  }
}