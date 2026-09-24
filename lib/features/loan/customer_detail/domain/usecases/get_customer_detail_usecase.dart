import '../entities/customer_detail_entity.dart';
import '../repositories/customer_repository.dart';

class GetCustomerDetailUseCase {
  final CustomerRepository repository;

  GetCustomerDetailUseCase(this.repository);

  Future<CustomerDetailEntity> call() async {
    return await repository.getCustomerDetail();
  }
}