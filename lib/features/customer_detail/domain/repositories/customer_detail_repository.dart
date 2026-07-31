import '../entities/customer_detail_entity.dart';

abstract class CustomerDetailRepository {
  Future<CustomerDetailEntity> getCustomerDetail(String customerId);
}