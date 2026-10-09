import '../../domain/entities/enach_request_entity.dart';

class EnachRequestModel extends EnachRequestEntity {
  const EnachRequestModel({
    required super.id,
    required super.customerName,
    required super.customerId,
    required super.appliedDate,
    required super.status,
    required super.imageUrl,
  });

  factory EnachRequestModel.fromJson(Map<String, dynamic> json) {
    return EnachRequestModel(
      id: json['id'],
      customerName: json['customerName'],
      customerId: json['customerId'],
      appliedDate: json['appliedDate'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }
}