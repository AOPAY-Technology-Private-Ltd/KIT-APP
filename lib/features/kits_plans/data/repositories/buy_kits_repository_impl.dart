import '../../data/models/payment_gateway_request_model.dart';
import '../../data/models/save_purchase_history_request_model.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/buy_kits_repository.dart';
import '../datasources/buy_kits_remote_data_source.dart';

class BuyKitsRepositoryImpl implements BuyKitsRepository {
  final BuyKitsRemoteDataSource remoteDataSource;

  BuyKitsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PlanEntity>> getPlans() async {
    return await remoteDataSource.fetchPlans();
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    return await remoteDataSource.fetchPaymentMethods();
  }

  @override
  Future<Map<String, dynamic>> triggerPaymentGateway(PaymentGatewayRequestModel requestModel) async {
    return await remoteDataSource.triggerPaymentGateway(requestModel);
  }

  @override
  Future<Map<String, dynamic>> savePurchaseHistory(SavePurchaseHistoryRequestModel requestModel) async {
    return await remoteDataSource.savePurchaseHistory(requestModel);
  }
}