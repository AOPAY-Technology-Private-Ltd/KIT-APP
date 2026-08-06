abstract class PaymentSuccessEvent {}

class SaveAndInitializeSuccessEvent extends PaymentSuccessEvent {
  final String invoiceNo;
  final int kitsCount;
  final double netAmount;
  final String paymentMode;
  final String planCode;
  final String mappingCode;
  final double planAmount;
  final double discountAmount;
  final double gstAmount;

  SaveAndInitializeSuccessEvent({
    required this.invoiceNo,
    required this.kitsCount,
    required this.netAmount,
    required this.paymentMode,
    required this.planCode,
    required this.mappingCode,
    required this.planAmount,
    required this.discountAmount,
    required this.gstAmount,
  });
}