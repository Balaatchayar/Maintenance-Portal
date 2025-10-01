class NotificationResponse {
  final String plantId;
  final List<NotificationItem> notifications;

  NotificationResponse({
    required this.plantId,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      plantId: json['plantId'] ?? '',
      notifications: (json['notifications'] as List<dynamic>?)
          ?.map((notification) => NotificationItem.fromJson(notification))
          .toList() ?? [],
    );
  }
}

class NotificationItem {
  final String? notificationNo;
  final String? date;
  final String? type;
  final String? description;
  final String priority;

  NotificationItem({
    this.notificationNo,
    this.date,
    this.type,
    this.description,
    required this.priority,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationNo: json['notificationNo'],
      date: json['date'],
      type: json['type'],
      description: json['description'],
      priority: json['priority'] ?? 'N/A',
    );
  }

  bool get isOpen => priority != 'CLOSED';
}