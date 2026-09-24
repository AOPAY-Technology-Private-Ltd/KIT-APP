import '../entities/customer_detail_entity.dart';
import '../repositories/customer_detail_repository.dart';

class GetCustomerDetailUseCase {
  final CustomerDetailRepository repository;

  GetCustomerDetailUseCase(this.repository);

  Future<CustomerDetailEntity> call(String customerId) async {
    return await repository.getCustomerDetail(customerId);
  }
}