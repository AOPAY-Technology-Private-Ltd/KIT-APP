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
    final customerDetails = json['customerDetails'] ?? {};
    final productDetails = json['productDetails'] ?? {};
    final createLoanDetails = json['createLoanDetails'] ?? {};

    // First name aur Last name ko combine karke full name bana rahe hain
    final firstName = customerDetails['firstName'] ?? '';
    final lastName = customerDetails['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();

    return CustomerDetailModel(
      customerName: fullName.isNotEmpty ? fullName : 'N/A',
      customerId: customerDetails['customerCode'] ?? '',
      avatarUrl: customerDetails['custPhoto_path'] ?? '',
      status: customerDetails['activeStatus'] ?? '',
      loanNumber: createLoanDetails['loanCode'] ?? '',
      nextEmiDate: createLoanDetails['loanStartDate'] ?? '',
      loanType: 'Device Loan', // API ke mutabiq default ya dynamic
      loanCategory: productDetails['brandName'] ?? '',
      emiAmount: double.tryParse(productDetails['emiAmount']?.toString() ?? '0') ?? 0.0,
      loanAmount: double.tryParse(productDetails['loanAmount']?.toString() ?? '0') ?? 0.0,
      downPayment: double.tryParse(productDetails['downPayment']?.toString() ?? '0') ?? 0.0,
      startDate: createLoanDetails['loanStartDate'] ?? '',
      endDate: createLoanDetails['loanEndDate'] ?? '',
      totalEmiCount: int.tryParse(productDetails['tenure']?.toString() ?? '0') ?? 0,
      paidEmiCount: 0, // Agar paid count API me nahi hai toh default 0
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