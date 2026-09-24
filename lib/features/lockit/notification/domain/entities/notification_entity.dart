class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}