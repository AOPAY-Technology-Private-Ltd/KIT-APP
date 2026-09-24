class Invoice {
  final String id;
  final String invoiceNumber;
  final String date;
  final String kitsInfo;
  final double amount;
  final String sectionCategory;
  final double planAmount;
  final double gstAmount;
  final String paymentMode;
  final String transactionNo;
  final String paymentStatus;
  final String remarks;

  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.kitsInfo,
    required this.amount,
    required this.sectionCategory,
    required this.planAmount,
    required this.gstAmount,
    required this.paymentMode,
    required this.transactionNo,
    required this.paymentStatus,
    required this.remarks,
  });
}