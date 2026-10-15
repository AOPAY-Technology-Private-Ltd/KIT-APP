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
      customerName: json['customerName']?.toString() ?? 'N/A',
      customerId: json['customerCode']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? json['custPhotoUrl']?.toString() ?? '',
      status: json['customerStatus']?.toString() ?? 'Approved',
      loanNumber: json['loanCode']?.toString() ?? '',
      nextEmiDate: json['nextEmiDate']?.toString() ?? json['startDate']?.toString() ?? '',
      loanType: json['loanType']?.toString() ?? 'Device Loan',
      loanCategory: json['loanCategory']?.toString() ?? '',
      emiAmount: double.tryParse(json['currentEmiAmount']?.toString() ?? json['monthlyEmi']?.toString() ?? '0') ?? 0.0,
      loanAmount: double.tryParse(json['loanAmount']?.toString() ?? '0') ?? 0.0,
      downPayment: double.tryParse(json['downPayment']?.toString() ?? '0') ?? 0.0,
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      totalEmiCount: int.tryParse(json['totalEmiCount']?.toString() ?? '0') ?? 0,
      paidEmiCount: int.tryParse(json['paidEmiCount']?.toString() ?? '0') ?? 0,
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