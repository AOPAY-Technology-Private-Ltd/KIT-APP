import '../../domain/repositories/customer_detail_repository.dart';
import '../datasources/customer_detail_remote_data_source.dart';
import '../models/app_master_model.dart';
import '../../domain/entities/customer_detail_entity.dart';

class CustomerDetailRepositoryImpl implements CustomerDetailRepository {
  final CustomerDetailRemoteDataSource remoteDataSource;

  CustomerDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerDetailEntity> getCustomerDetail(String customerIdentifier) async {
    return await remoteDataSource.getCustomerDetail(customerIdentifier);
  }

  @override
  Future<AppMasterModel> getAppMaster([String customerCode = '']) async {
    return await remoteDataSource.getAppMaster(customerCode);
  }

  @override
  Future<Map<String, dynamic>> getSuccessDeviceActions({
    required String customerCode,
    required String clientCode,
  }) async {
    return await remoteDataSource.getSuccessDeviceActions(
      customerCode: customerCode,
      clientCode: clientCode,
    );
  }

  @override
  Future<bool> saveDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    List<Map<String, dynamic>>? selectedApps,
  }) async {
    return await remoteDataSource.saveDeviceAction(
      customerCode: customerCode,
      notificationCode: notificationCode,
      actionStatus: actionStatus,
      selectedApps: selectedApps,
    );
  }

  @override
  Future<bool> sendDeviceNotification({
    required String customerCode,
    required String notificationCode,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  }) async {
    return await remoteDataSource.sendDeviceNotification(
      customerCode: customerCode,
      notificationCode: notificationCode,
      devicePin: devicePin,
      selectedApps: selectedApps,
    );
  }

  @override
  Future<bool> saveAndNotifyDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  }) async {
    return await remoteDataSource.saveAndNotifyDeviceAction(
      customerCode: customerCode,
      notificationCode: notificationCode,
      actionStatus: actionStatus,
      devicePin: devicePin,
      selectedApps: selectedApps,
    );
  }
}