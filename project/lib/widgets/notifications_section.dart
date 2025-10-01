import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';

class NotificationsSection extends StatefulWidget {
  final NotificationResponse? notifications;

  const NotificationsSection({super.key, this.notifications});

  @override
  State<NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<NotificationsSection> {
  bool _showOnlyOpen = false;

  @override
  Widget build(BuildContext context) {
    if (widget.notifications == null) {
      return const Center(
        child: Text('No notifications data available'),
      );
    }

    final allNotifications = widget.notifications!.notifications;
    final filteredNotifications = _showOnlyOpen
        ? allNotifications.where((n) => n.isOpen).toList()
        : allNotifications;

    return Column(
      children: [
        // Filter Controls
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Plant: ${widget.notifications!.plantId}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              FilterChip(
                label: const Text('Open Only'),
                selected: _showOnlyOpen,
                onSelected: (selected) => setState(() => _showOnlyOpen = selected),
              ),
            ],
          ),
        ),
        
        // Statistics
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  allNotifications.length.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Open',
                  allNotifications.where((n) => n.isOpen).length.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Closed',
                  allNotifications.where((n) => !n.isOpen).length.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Notifications List
        Expanded(
          child: filteredNotifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _showOnlyOpen
                            ? 'No open notifications'
                            : 'No notifications available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = filteredNotifications[index];
                    return _buildNotificationCard(notification);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final isOpen = notification.isOpen;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOpen ? Colors.orange : Colors.green,
          child: Icon(
            isOpen ? Icons.notification_important : Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.description ?? 'No description',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (notification.notificationNo != null)
              Text('Notification: ${notification.notificationNo}'),
            if (notification.type != null)
              Text('Type: ${notification.type}'),
            if (notification.date != null)
              Text('Date: ${_formatDate(notification.date!)}'),
          ],
        ),
        trailing: Chip(
          label: Text(
            notification.priority,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: _getPriorityColor(notification.priority),
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'HIGH':
        return Colors.red.shade100;
      case 'MEDIUM':
        return Colors.orange.shade100;
      case 'LOW':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}