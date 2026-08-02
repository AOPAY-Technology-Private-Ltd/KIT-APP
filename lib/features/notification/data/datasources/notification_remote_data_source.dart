import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final List<Map<String, dynamic>> responseData = [
      {
        'id': 'notif_1',
        'title': 'EMI Received',
        'message': 'Payment of ₹5,000 received for device ID #DEV8923.',
        'time': '5 mins ago',
        'isRead': false,
      },
      {
        'id': 'notif_2',
        'title': 'Security Alert',
        'message': 'Device #DEV4312 attempted to bypass security lock.',
        'time': '1 hour ago',
        'isRead': false,
      },
      {
        'id': 'notif_3',
        'title': 'Kit Assigned',
        'message': '10 new retailer kits have been successfully credited.',
        'time': 'Yesterday',
        'isRead': true,
      },
    ];

    return responseData.map((json) => NotificationModel.fromJson(json)).toList();
  }
}