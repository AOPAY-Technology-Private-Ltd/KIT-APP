import '../../domain/entities/customer_detail_entity.dart';

class CustomerDetailModel extends CustomerDetailEntity {
  const CustomerDetailModel({
    required super.id,
    required super.name,
    required super.customerCode,
    required super.email,
    required super.mobile,
    required super.imei,
    required super.address,
    required super.imageUrl,
    required super.status,
    required super.emiAmount,
    required super.emiDate,
    required super.isLocked,
    super.brand,
    super.manufacturer,
    super.frp,
    super.imeiSlot1,
    super.imeiSlot2,
    super.model,
    super.purchaseDate,
    super.serialNumber,
  });

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      customerCode: json['customerCode'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      imei: json['imei'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      status: json['status'] ?? 'Active',
      emiAmount: (json['emiAmount'] ?? 0.0).toDouble(),
      emiDate: json['emiDate'] ?? '',
      isLocked: json['isLocked'] ?? false,
      brand: json['brand'],
      manufacturer: json['manufacturer'],
      frp: json['frp'],
      imeiSlot1: json['imeiSlot1'],
      imeiSlot2: json['imeiSlot2'],
      model: json['model'],
      purchaseDate: json['purchaseDate'],
      serialNumber: json['serialNumber'],
    );
  }
}