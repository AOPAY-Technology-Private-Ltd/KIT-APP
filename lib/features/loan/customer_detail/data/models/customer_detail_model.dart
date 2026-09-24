import '../../domain/entities/customer_detail_entity.dart';

class CustomerDetailModel extends CustomerDetailEntity {
  const CustomerDetailModel({
    required super.customerName,
    required super.customerId,
    required super.avatarUrl,
    required super.status,
    required super.loanNumber,
    required super.nextEmiDate,
    required super.loanType,
    required super.loanCategory,
    required super.emiAmount,
    required super.loanAmount,
    required super.downPayment,
    required super.startDate,
    required super.endDate,
    required super.totalEmiCount,
    required super.paidEmiCount,
  });

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailModel(
      customerName: json['customerName'] ?? '',
      customerId: json['customerId'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      status: json['status'] ?? '',
      loanNumber: json['loanNumber'] ?? '',
      nextEmiDate: json['nextEmiDate'] ?? '',
      loanType: json['loanType'] ?? '',
      loanCategory: json['loanCategory'] ?? '',
      emiAmount: (json['emiAmount'] ?? 0.0).toDouble(),
      loanAmount: (json['loanAmount'] ?? 0.0).toDouble(),
      downPayment: (json['downPayment'] ?? 0.0).toDouble(),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalEmiCount: json['totalEmiCount'] ?? 0,
      paidEmiCount: json['paidEmiCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerId': customerId,
      'avatarUrl': avatarUrl,
      'status': status,
      'loanNumber': loanNumber,
      'nextEmiDate': nextEmiDate,
      'loanType': loanType,
      'loanCategory': loanCategory,
      'emiAmount': emiAmount,
      'loanAmount': loanAmount,
      'downPayment': downPayment,
      'startDate': startDate,
      'endDate': endDate,
      'totalEmiCount': totalEmiCount,
      'paidEmiCount': paidEmiCount,
    };
  }
}