import '../../data/models/payment_gateway_request_model.dart';
import '../repositories/buy_kits_repository.dart';

class TriggerPaymentGatewayUseCase {
  final BuyKitsRepository repository;

  TriggerPaymentGatewayUseCase(this.repository);

  Future<Map<String, dynamic>> execute(PaymentGatewayRequestModel requestModel) async {
    return await repository.triggerPaymentGateway(requestModel);
  }
}