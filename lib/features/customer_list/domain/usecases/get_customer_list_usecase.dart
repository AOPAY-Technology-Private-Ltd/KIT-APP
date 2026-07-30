import '../entities/customer_item_entity.dart';
import '../repositories/customer_list_repository.dart';

class GetCustomerListUseCase {
  final CustomerListRepository repository;

  GetCustomerListUseCase(this.repository);

  Future<List<CustomerItemEntity>> call() async {
    return await repository.getCustomerList();
  }
}