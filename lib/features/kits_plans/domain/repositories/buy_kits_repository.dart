import '../../data/models/payment_gateway_request_model.dart';
import '../../data/models/save_purchase_history_request_model.dart';
import '../entities/plan_entity.dart';

abstract class BuyKitsRepository {
  Future<List<PlanEntity>> getPlans();
  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<Map<String, dynamic>> triggerPaymentGateway(PaymentGatewayRequestModel requestModel);

  Future<Map<String, dynamic>> savePurchaseHistory(SavePurchaseHistoryRequestModel requestModel);
}