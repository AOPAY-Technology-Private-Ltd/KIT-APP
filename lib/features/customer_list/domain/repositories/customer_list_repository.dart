import '../entities/customer_item_entity.dart';

abstract class CustomerListRepository {
  Future<List<CustomerItemEntity>> getCustomerList();
}