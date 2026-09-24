import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final List<Map<String, dynamic>> responseData = [];

    return responseData.map((json) => NotificationModel.fromJson(json)).toList();
  }
}