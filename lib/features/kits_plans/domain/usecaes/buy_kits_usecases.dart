import '../repositories/buy_kits_repository.dart';

class GetBuyKitsDataUseCase {
  final BuyKitsRepository repository;

  GetBuyKitsDataUseCase(this.repository);

  Future<Map<String, dynamic>> execute() async {
    final plans = await repository.getPlans();
    final paymentMethods = await repository.getPaymentMethods();
    return {
      'plans': plans,
      'paymentMethods': paymentMethods,
    };
  }
}