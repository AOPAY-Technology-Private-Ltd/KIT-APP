import '../../domain/entities/plan_entity.dart';

class PlanModel extends PlanEntity {
  final String mappingCode;
  final String planCode;
  final double discountPercent;
  final double gstPercent;

  const PlanModel({
    required super.id,
    required super.kitsCount,
    required super.price,
    required super.pricePerKit,
    super.discountLabel,
    super.isMostPopular,
    required this.mappingCode,
    required this.planCode,
    required this.discountPercent,
    required this.gstPercent,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['mappingCode']?.toString() ?? '',
      kitsCount: json['noOfKits'] ?? 0,
      price: (json['planAmount'] ?? 0.0).toDouble(),
      pricePerKit: (json['pricePerKit'] ?? 0.0).toDouble(),
      discountLabel: json['discountPercent'] != null ? 'Save ${json['discountPercent']}%' : null,
      isMostPopular: json['isDefault'] ?? false,
      mappingCode: json['mappingCode'] ?? '',
      planCode: json['planCode'] ?? '',
      discountPercent: (json['discountPercent'] ?? 0.0).toDouble(),
      gstPercent: (json['gstPercent'] ?? 18.0).toDouble(),
    );
  }

  static List<PaymentMethodEntity> getMockPaymentMethods() {
    return [
      const PaymentMethodEntity(
        id: 'upi',
        name: 'UPI',
        description: 'Pay via Google Pay, Phonepe, Paytm',
        icon: 'upi',
      ),
      const PaymentMethodEntity(
        id: 'card',
        name: 'Credit / Debit Card',
        description: 'Visa, MasterCard, Rupay',
        icon: 'card',
      ),
      const PaymentMethodEntity(
        id: 'net_banking',
        name: 'Net Banking',
        description: 'All Major Banks',
        icon: 'net_banking',
      ),
    ];
  }
}