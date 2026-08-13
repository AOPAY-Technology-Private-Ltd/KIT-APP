import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required String id,
    required String title,
    required String message,
    required String time,
    required bool isRead,
  }) : super(
    id: id,
    title: title,
    message: message,
    time: time,
    isRead: isRead,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      time: json['time'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'isRead': isRead,
    };
  }
}