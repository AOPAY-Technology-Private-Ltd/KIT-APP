import '../../data/models/app_master_model.dart';
import '../entities/customer_detail_entity.dart';

abstract class CustomerDetailRepository {
  Future<CustomerDetailEntity> getCustomerDetail(String customerIdentifier);
  Future<AppMasterModel> getAppMaster([String customerCode = '']);
  Future<Map<String, dynamic>> getSuccessDeviceActions({
    required String customerCode,
    required String clientCode,
  });
  Future<bool> saveDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    List<Map<String, dynamic>>? selectedApps,
  });
  Future<bool> sendDeviceNotification({
    required String customerCode,
    required String notificationCode,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  });
  Future<bool> saveAndNotifyDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  });
}