class Invoice {
  final String id;
  final String invoiceNumber;
  final String date;
  final String kitsInfo;
  final double amount;
  final String sectionCategory;

  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.kitsInfo,
    required this.amount,
    required this.sectionCategory,
  });
}