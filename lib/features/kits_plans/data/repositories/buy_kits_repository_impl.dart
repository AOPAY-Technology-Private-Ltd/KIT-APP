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
}