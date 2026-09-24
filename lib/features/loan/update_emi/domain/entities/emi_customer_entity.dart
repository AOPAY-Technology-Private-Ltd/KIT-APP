class EmiUpdateEntity {
  final String loanId;
  final String numberOfEmi;
  final String paymentMode;
  final double emiAmount;
  final double? lateFees;
  final double? bounceCharges;
  final String paymentDate;
  final String status;
  final String transactionId;

  const EmiUpdateEntity({
    required this.loanId,
    required this.numberOfEmi,
    required this.paymentMode,
    required this.emiAmount,
    this.lateFees,
    this.bounceCharges,
    required this.paymentDate,
    required this.status,
    required this.transactionId,
  });
}