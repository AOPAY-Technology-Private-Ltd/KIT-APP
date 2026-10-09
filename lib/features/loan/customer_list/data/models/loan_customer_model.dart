import '../../domain/entities/loan_customer_entity.dart';

class LoanCustomerModel extends LoanCustomerEntity {
  const LoanCustomerModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.profileImage,
    required super.loanId,
    required super.principal,
    required super.monthlyEmi,
    required super.nextPaymentDate,
    required super.emIsRemaining,
    required super.status,
    required super.customerCode,
    required super.currentStep,
  });

  factory LoanCustomerModel.fromJson(Map<String, dynamic> json) {
    return LoanCustomerModel(
      id: json['customerCode']?.toString() ?? '',
      name: json['fullName']?.toString().replaceAll(RegExp(r'\s+'), ' ').trim() ?? 'Unknown',
      phone: json['mobileNumber']?.toString() ?? '',
      email: '',
      profileImage: json['customerImage']?.toString() ?? '',
      loanId: json['customerCode']?.toString() ?? '',
      principal: '0',
      monthlyEmi: '0',
      nextPaymentDate: '',
      emIsRemaining: json['currentStep']?.toString() ?? '',
      status: json['customerStatus']?.toString() ?? 'Active',
      customerCode: json['customerCode']?.toString() ?? '',
      currentStep: json['currentStep']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerCode': id,
      'fullName': name,
      'mobileNumber': phone,
      'customerImage': profileImage,
      'customerStatus': status,
      'currentStep': currentStep,
    };
  }
}