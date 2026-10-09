import '../../domain/entities/enach_review_entity.dart';

class EnachReviewModel extends EnachReviewEntity {
  EnachReviewModel({
    required super.customerId,
    required super.customerName,
    required super.appliedDate,
    required super.imageUrl,
    required super.currentBankName,
    required super.currentAccountNumber,
    required super.requestedBankName,
    required super.requestedAccountNumber,
    required super.ifscCode,
    required super.branchName,
    required super.status,
  });

  factory EnachReviewModel.fromJson(Map<String, dynamic> json) {
    return EnachReviewModel(
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      appliedDate: json['applied_date'] ?? '',
      imageUrl: json['image_url'] ?? '',
      currentBankName: json['current_bank_name'] ?? '',
      currentAccountNumber: json['current_account_number'] ?? '',
      requestedBankName: json['requested_bank_name'] ?? '',
      requestedAccountNumber: json['requested_account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      branchName: json['branch_name'] ?? '',
      status: json['status'] ?? 'Review',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'applied_date': appliedDate,
      'image_url': imageUrl,
      'current_bank_name': currentBankName,
      'current_account_number': currentAccountNumber,
      'requested_bank_name': requestedBankName,
      'requested_account_number': requestedAccountNumber,
      'ifsc_code': ifscCode,
      'branch_name': branchName,
      'status': status,
    };
  }
}