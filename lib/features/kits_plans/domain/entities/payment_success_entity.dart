class PaymentSuccessEntity {
  final String orderId;
  final int kitsCount;
  final double totalPaid;
  final String paymentMethod;

  PaymentSuccessEntity({
    required this.orderId,
    required this.kitsCount,
    required this.totalPaid,
    required this.paymentMethod,
  });
}