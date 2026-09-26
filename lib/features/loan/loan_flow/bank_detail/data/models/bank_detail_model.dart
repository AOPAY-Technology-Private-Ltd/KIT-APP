import '../../domain/entities/bank_detail_entity.dart';

class BankDetailModel extends BankDetailEntity {
  const BankDetailModel({
    required super.paymentMode,
    required super.bankName,
    required super.accountType,
    required super.accountNumber,
    required super.confirmAccountNumber,
    required super.beneficiaryName,
    required super.ifscCode,
    required super.branchName,
  });

  factory BankDetailModel.fromEntity(BankDetailEntity entity) {
    return BankDetailModel(
      paymentMode: entity.paymentMode,
      bankName: entity.bankName,
      accountType: entity.accountType,
      accountNumber: entity.accountNumber,
      confirmAccountNumber: entity.confirmAccountNumber,
      beneficiaryName: entity.beneficiaryName,
      ifscCode: entity.ifscCode,
      branchName: entity.branchName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_mode': paymentMode,
      'bank_name': bankName,
      'account_type': accountType,
      'account_number': accountNumber,
      'confirm_account_number': confirmAccountNumber,
      'beneficiary_name': beneficiaryName,
      'ifsc_code': ifscCode,
      'branch_name': branchName,
    };
  }
}