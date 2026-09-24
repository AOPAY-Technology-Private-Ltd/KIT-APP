import '../../../../../core/constants/apiconstants/api_constants.dart';
import '../../domain/entities/customer_item_entity.dart';

class CustomerItemModel extends CustomerItemEntity {
  const CustomerItemModel({
    required super.id,
    required super.name,
    required super.customerIdCode,
    required super.email,
    required super.imageUrl,
    required super.mobile,
    required super.imei1,
    required super.imei2,
    required super.serialNumber,
    required super.purchaseDate,
    required super.scheduleLockStatus,
    required super.isLocked,
  });

  factory CustomerItemModel.fromJson(Map<String, dynamic> json) {
    String rawPath = json['custPhoto_path'] ?? json['imageUrl'] ?? json['custPhoto'] ?? '';
    String fullImageUrl = '';

    if (rawPath.isNotEmpty) {
      if (rawPath.startsWith('http')) {
        fullImageUrl = rawPath;
      } else {
        fullImageUrl = '${ApiConstants.mainBaseUrl}${rawPath.startsWith('/') ? '' : '/'}$rawPath';
      }
    }

    String firstName = json['firstName'] ?? '';
    String lastName = json['lastName'] ?? '';
    String fullName = json['name'] ?? (firstName.isNotEmpty ? '$firstName $lastName' : 'Customer');

    bool lockedStatus = json['isDeviceLocked'] ?? json['isLocked'] ?? false;

    return CustomerItemModel(
      id: json['id']?.toString() ?? json['srNo']?.toString() ?? '',
      name: fullName,
      customerIdCode: json['customerCodes'] ?? json['customerIdCode'] ?? json['code'] ?? '',
      email: json['eMailID'] ?? json['email'] ?? '',
      imageUrl: fullImageUrl,
      mobile: json['primaryMobileNumber'] ?? json['mobile'] ?? '',
      imei1: json['imeiNumber1'] ?? json['imei1'] ?? '',
      imei2: json['imeiNumber2'] ?? json['imei2'] ?? '',
      serialNumber: json['serialNumber'] ?? json['serialNo'] ?? '',
      purchaseDate: json['purchaseDate'] ?? json['createdDate'] ?? '',
      scheduleLockStatus: lockedStatus ? 'ON' : 'OFF',
      isLocked: lockedStatus,
    );
  }
}