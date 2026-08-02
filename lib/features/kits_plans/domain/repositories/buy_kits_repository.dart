import '../entities/plan_entity.dart';

abstract class BuyKitsRepository {
  Future<List<PlanEntity>> getPlans();
  Future<List<PaymentMethodEntity>> getPaymentMethods();
}