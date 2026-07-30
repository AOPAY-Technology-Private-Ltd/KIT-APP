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
    return CustomerItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Pinki Sethi',
      customerIdCode: json['customerIdCode'] ?? 'PS1234567809',
      email: json['email'] ?? 'pyaazaloo@gmai.com',
      imageUrl: json['imageUrl'] ?? '',
      mobile: json['mobile'] ?? '8929898901',
      imei1: json['imei1'] ?? '869663047581173',
      imei2: json['imei2'] ?? '869663047581165',
      serialNumber: json['serialNumber'] ?? '1781092325834',
      purchaseDate: json['purchaseDate'] ?? '10-06-2026, 05:22 PM',
      scheduleLockStatus: json['scheduleLockStatus'] ?? 'ON',
      isLocked: json['isLocked'] ?? false,
    );
  }
}