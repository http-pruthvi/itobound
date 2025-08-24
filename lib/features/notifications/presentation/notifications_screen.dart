import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/ito_bound_theme.dart';
import '../../../core/services/demo_data_service.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = _getDemoNotifications();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Activity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Notifications list
              Expanded(
                child: notifications.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return _NotificationItem(
                            notification: notification,
                            index: index,
                          );
                        },
                      )
                    : _buildEmptyState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Activity Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When someone likes or messages you,\nyou\'ll see it here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDemoNotifications() {
    return [
      {
        'type': 'like',
        'title': 'New Like',
        'message': 'Sarah liked your photo',
        'time': '2 min ago',
        'avatar': 'https://via.placeholder.com/150',
        'isRead': false,
      },
      {
        'type': 'match',
        'title': 'It\'s a Match!',
        'message': 'You and Emma liked each other',
        'time': '1 hour ago',
        'avatar': 'https://via.placeholder.com/150',
        'isRead': false,
      },
      {
        'type': 'message',
        'title': 'New Message',
        'message': 'Alex sent you a message',
        'time': '3 hours ago',
        'avatar': 'https://via.placeholder.com/150',
        'isRead': true,
      },
      {
        'type': 'super_like',
        'title': 'Super Like',
        'message': 'Maya super liked you!',
        'time': '1 day ago',
        'avatar': 'https://via.placeholder.com/150',
        'isRead': true,
      },
    ];
  }
}

class _NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  final int index;

  const _NotificationItem({
    required this.notification,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead'] 
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(notification['avatar']),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification['type']),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(
                  _getNotificationIcon(notification['type']),
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          notification['title'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification['time'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: !notification['isRead']
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Handle notification tap
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opened ${notification['title']}'),
              backgroundColor: _getNotificationColor(notification['type']),
            ),
          );
        },
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.3, end: 0);
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return Colors.red;
      case 'match':
        return Colors.pink;
      case 'message':
        return Colors.blue;
      case 'super_like':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'match':
        return Icons.favorite;
      case 'message':
        return Icons.message;
      case 'super_like':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }
}