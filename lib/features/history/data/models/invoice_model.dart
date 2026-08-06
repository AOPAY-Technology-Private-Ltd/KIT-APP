import '../../domain/entities/entities.dart' show Invoice;

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.invoiceNumber,
    required super.date,
    required super.kitsInfo,
    required super.amount,
    required super.sectionCategory,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['purchaseCode']?.toString() ?? json['id']?.toString() ?? '',
      invoiceNumber: json['purchaseCode'] ?? json['invoiceNumber'] ?? json['invoiceNo'] ?? 'N/A',
      date: json['purchaseDate'] ?? json['date'] ?? json['createdDate'] ?? '',
      kitsInfo: json['planName'] ?? json['kitsInfo'] ?? json['kits'] ?? '',
      amount: (json['netAmount'] ?? json['amount'] ?? json['totalAmount'] ?? 0.0).toDouble(),
      sectionCategory: json['sectionCategory'] ?? json['category'] ?? 'Recent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'date': date,
      'kitsInfo': kitsInfo,
      'amount': amount,
      'sectionCategory': sectionCategory,
    };
  }
}