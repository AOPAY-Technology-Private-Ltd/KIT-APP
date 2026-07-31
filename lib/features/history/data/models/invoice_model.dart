
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
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      date: json['date'],
      kitsInfo: json['kitsInfo'],
      amount: json['amount'],
      sectionCategory: json['sectionCategory'],
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