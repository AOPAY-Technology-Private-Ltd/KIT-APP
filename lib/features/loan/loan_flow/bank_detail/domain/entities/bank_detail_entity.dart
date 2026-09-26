class BankDetailEntity {
  final String paymentMode;
  final String bankName;
  final String accountType;
  final String accountNumber;
  final String confirmAccountNumber;
  final String beneficiaryName;
  final String ifscCode;
  final String branchName;

  const BankDetailEntity({
    required this.paymentMode,
    required this.bankName,
    required this.accountType,
    required this.accountNumber,
    required this.confirmAccountNumber,
    required this.beneficiaryName,
    required this.ifscCode,
    required this.branchName,
  });
}