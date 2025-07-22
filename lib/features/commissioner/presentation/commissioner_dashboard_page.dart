import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class CommissionerDashboardPage extends StatelessWidget {
  const CommissionerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commissioner Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsGrid(context),
            const SizedBox(height: AppConstants.defaultPadding * 2),
            Text(
              'Recent Listings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildRecentListings(),
            const SizedBox(height: AppConstants.defaultPadding * 2),
            Text(
              'Recent Activities',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildRecentActivities(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new listing
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppConstants.defaultPadding,
      mainAxisSpacing: AppConstants.defaultPadding,
      children: [
        _buildStatCard(
          context,
          'Active Listings',
          '12',
          Icons.home,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          'Total Views',
          '1.2K',
          Icons.visibility,
          Colors.green,
        ),
        _buildStatCard(context, 'Bookings', '25', Icons.book, Colors.orange),
        _buildStatCard(
          context,
          'Revenue',
          '\$5.2K',
          Icons.attach_money,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentListings() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image),
            ),
            title: Text('Property ${index + 1}'),
            subtitle: Text('Listed ${3 - index} days ago'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to listing detail
            },
          ),
        );
      },
    );
  }

  Widget _buildRecentActivities() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Icon(_getActivityIcon(index))),
          title: Text(_getActivityTitle(index)),
          subtitle: Text(_getActivityTime(index)),
          onTap: () {
            // TODO: Navigate to activity detail
          },
        );
      },
    );
  }

  IconData _getActivityIcon(int index) {
    switch (index % 3) {
      case 0:
        return Icons.visibility;
      case 1:
        return Icons.message;
      default:
        return Icons.book;
    }
  }

  String _getActivityTitle(int index) {
    switch (index % 3) {
      case 0:
        return 'New viewing request for Property ${index + 1}';
      case 1:
        return 'Message from potential tenant';
      default:
        return 'New booking request';
    }
  }

  String _getActivityTime(int index) {
    switch (index) {
      case 0:
        return 'Just now';
      case 1:
        return '2 hours ago';
      case 2:
        return '5 hours ago';
      default:
        return 'Yesterday';
    }
  }
}
