import '../entities/customer_detail_entity.dart';

abstract class CustomerRepository {
  Future<CustomerDetailEntity> getCustomerDetail({required String searchText});
}