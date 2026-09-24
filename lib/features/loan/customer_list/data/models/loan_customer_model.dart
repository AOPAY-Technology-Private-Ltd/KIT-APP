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
  });

  factory LoanCustomerModel.fromJson(Map<String, dynamic> json) {
    return LoanCustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
      loanId: json['loanId']?.toString() ?? '',
      principal: json['principal']?.toString() ?? '0',
      monthlyEmi: json['monthlyEmi']?.toString() ?? '0',
      nextPaymentDate: json['nextPaymentDate']?.toString() ?? '',
      emIsRemaining: json['emIsRemaining']?.toString() ?? '',
      status: json['status']?.toString() ?? 'On track',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profileImage': profileImage,
      'loanId': loanId,
      'principal': principal,
      'monthlyEmi': monthlyEmi,
      'nextPaymentDate': nextPaymentDate,
      'emIsRemaining': emIsRemaining,
      'status': status,
    };
  }
}