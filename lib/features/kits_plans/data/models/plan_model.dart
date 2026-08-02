import '../../domain/entities/plan_entity.dart';

class PlanModel extends PlanEntity {
  const PlanModel({
    required super.id,
    required super.kitsCount,
    required super.price,
    required super.pricePerKit,
    super.discountLabel,
    super.isMostPopular,
  });

  static List<PlanModel> getMockPlans() {
    return [
      const PlanModel(
        id: '1',
        kitsCount: 10,
        price: 4999,
        pricePerKit: 499,
      ),
      const PlanModel(
        id: '2',
        kitsCount: 25,
        price: 12475,
        pricePerKit: 499,
        discountLabel: 'Save 6%',
      ),
      const PlanModel(
        id: '3',
        kitsCount: 50,
        price: 24950,
        pricePerKit: 499,
        discountLabel: 'Save 13%',
        isMostPopular: true,
      ),
      const PlanModel(
        id: '4',
        kitsCount: 100,
        price: 49900,
        pricePerKit: 499,
        discountLabel: 'Save 20%',
      ),
      const PlanModel(
        id: '5',
        kitsCount: 150,
        price: 74850,
        pricePerKit: 499,
        discountLabel: 'Save 23%',
      ),
      const PlanModel(
        id: '6',
        kitsCount: 200,
        price: 99800,
        pricePerKit: 499,
        discountLabel: 'Save 25%',
      ),
    ];
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