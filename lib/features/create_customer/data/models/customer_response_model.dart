import '../../domain/entities/customer_entity.dart';

class CustomerResponseModel extends CustomerEntity {
  const CustomerResponseModel({
    required super.message,
    required super.success,
  });

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}