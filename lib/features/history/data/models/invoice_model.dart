import '../../domain/entities/entities.dart' show Invoice;

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.id,
    required super.invoiceNumber,
    required super.date,
    required super.kitsInfo,
    required super.amount,
    required super.sectionCategory,
    required super.planAmount,
    required super.gstAmount,
    required super.paymentMode,
    required super.transactionNo,
    required super.paymentStatus,
    required super.remarks,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['purchaseCode']?.toString() ?? json['id']?.toString() ?? '',
      invoiceNumber: json['invoiceNo'] ?? json['purchaseCode'] ?? 'N/A',
      date: json['purchaseDate'] ?? json['date'] ?? '',
      kitsInfo: json['remarks'] ?? json['planName'] ?? 'Kit Purchase',
      amount: (json['netAmount'] ?? json['amount'] ?? 0.0).toDouble(),
      sectionCategory: json['paymentStatus'] ?? json['sectionCategory'] ?? 'SUCCESS',
      planAmount: (json['planAmount'] ?? 0.0).toDouble(),
      gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),
      paymentMode: json['paymentMode'] ?? 'UPI',
      transactionNo: json['transactionNo'] ?? 'N/A',
      paymentStatus: json['paymentStatus'] ?? 'SUCCESS',
      remarks: json['remarks'] ?? '',
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
      'planAmount': planAmount,
      'gstAmount': gstAmount,
      'paymentMode': paymentMode,
      'transactionNo': transactionNo,
      'paymentStatus': paymentStatus,
      'remarks': remarks,
    };
  }
}