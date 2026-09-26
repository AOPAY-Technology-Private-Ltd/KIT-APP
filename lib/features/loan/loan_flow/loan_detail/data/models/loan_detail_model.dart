import '../../domain/entities/loan_detail_entity.dart';

class LoanDetailModel extends LoanDetailEntity {
  LoanDetailModel({
    required super.productCategory,
    required super.brand,
    required super.model,
    required super.loanAmount,
    required super.downPayment,
    required super.processFees,
    required super.forecloseCharges,
    required super.interestType,
    required super.tenure,
    required super.interestRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'productCategory': productCategory,
      'brand': brand,
      'model': model,
      'loanAmount': loanAmount,
      'downPayment': downPayment,
      'processFees': processFees,
      'forecloseCharges': forecloseCharges,
      'interestType': interestType,
      'tenure': tenure,
      'interestRate': interestRate,
    };
  }
}