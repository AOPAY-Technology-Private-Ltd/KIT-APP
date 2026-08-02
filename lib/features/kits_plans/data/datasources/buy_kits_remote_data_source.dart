import '../../domain/entities/plan_entity.dart';

abstract class BuyKitsRemoteDataSource {
  Future<List<PlanEntity>> fetchPlans();
  Future<List<PaymentMethodEntity>> fetchPaymentMethods();
}

class BuyKitsRemoteDataSourceImpl implements BuyKitsRemoteDataSource {
  @override
  Future<List<PlanEntity>> fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      PlanEntity(
        id: '1',
        kitsCount: 1,
        price: 999,
        pricePerKit: 999,
        discountLabel: null,
        isMostPopular: false,
      ),
      PlanEntity(
        id: '2',
        kitsCount: 3,
        price: 2499,
        pricePerKit: 833,
        discountLabel: 'Save 15%',
        isMostPopular: true,
      ),
      PlanEntity(
        id: '3',
        kitsCount: 5,
        price: 3999,
        pricePerKit: 800,
        discountLabel: 'Save 20%',
        isMostPopular: false,
      ),
    ];
  }

  @override
  Future<List<PaymentMethodEntity>> fetchPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      PaymentMethodEntity(
        id: 'upi',
        name: 'UPI / QR Code',
        description: 'Google Pay, PhonePe, Paytm & more',
        icon: 'assets/icons/upi.png',
      ),
      PaymentMethodEntity(
        id: 'card',
        name: 'Credit / Debit Card',
        description: 'Visa, MasterCard, RuPay & others',
        icon: 'assets/icons/card.png',
      ),
      PaymentMethodEntity(
        id: 'netbanking',
        name: 'Net Banking',
        description: 'All major Indian banks supported',
        icon: 'assets/icons/netbanking.png',
      ),
    ];
  }
}