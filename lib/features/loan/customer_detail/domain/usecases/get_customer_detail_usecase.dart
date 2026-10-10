import '../../domain/entities/customer_detail_entity.dart';
import '../../domain/repositories/customer_repository.dart';

class GetCustomerDetailUseCase {
  final CustomerRepository repository;

  GetCustomerDetailUseCase(this.repository);

  Future<CustomerDetailEntity> call({required String searchText}) async {
    return await repository.getCustomerDetail(searchText: searchText);
  }
}