import 'package:flutter/material.dart';
//import '../../../core/constants.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // TODO: Mark all as read
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // TODO: Replace with actual notifications
        itemBuilder: (context, index) {
          final bool isRead = index % 3 == 0;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: isRead ? Colors.grey : Colors.blue,
              child: Icon(_getNotificationIcon(index), color: Colors.white),
            ),
            title: Text(
              _getNotificationTitle(index),
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _getNotificationDescription(index),
              style: TextStyle(color: isRead ? Colors.grey : null),
            ),
            trailing: Text(
              _getTimeAgo(index),
              style: TextStyle(
                color: isRead ? Colors.grey : null,
                fontSize: 12,
              ),
            ),
            onTap: () {
              // TODO: Handle notification tap
            },
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.message;
      case 2:
        return Icons.notifications;
      default:
        return Icons.info;
    }
  }

  String _getNotificationTitle(int index) {
    switch (index % 4) {
      case 0:
        return 'New Place Available';
      case 1:
        return 'New Message';
      case 2:
        return 'Booking Update';
      default:
        return 'System Update';
    }
  }

  String _getNotificationDescription(int index) {
    switch (index % 4) {
      case 0:
        return 'A new place matching your preferences is now available.';
      case 1:
        return 'You have a new message from your host.';
      case 2:
        return 'Your booking request has been approved.';
      default:
        return 'System maintenance completed successfully.';
    }
  }

  String _getTimeAgo(int index) {
    switch (index % 4) {
      case 0:
        return 'Just now';
      case 1:
        return '5m ago';
      case 2:
        return '1h ago';
      default:
        return '1d ago';
    }
  }
}
