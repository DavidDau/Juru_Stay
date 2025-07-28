import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommissionerDashboardPage extends StatelessWidget {
  const CommissionerDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blue;
    const backgroundColor = Colors.white;
    const textColor = Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Commissioner Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Greeting Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Replace with network if needed
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Welcome, Commissioner!',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Text('Your dashboard',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Dashboard Buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildDashboardButton(
                  icon: Icons.edit,
                  label: 'Edit Profile',
                  onTap: () {
                    context.push('/commissioner/profile');
                  },
                ),
                buildDashboardButton(
                  icon: Icons.add_location_alt,
                  label: 'Add Place',
                  onTap: () {
                    context.push('/add-place');
                  },
                ),
                buildDashboardButton(
                  icon: Icons.bar_chart,
                  label: 'Track Earnings',
                  onTap: () {
                    context.push('/track-earnings');
                  },
                ),
                buildDashboardButton(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    context.go('/'); // Or your logout handler
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
