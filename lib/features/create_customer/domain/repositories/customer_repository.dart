import '../../data/models/customer_request_model.dart';
import '../../data/models/customer_response_model.dart';
import '../entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<CustomerEntity> verifyCustomerKit({required String primaryMobileNumber});

  Future<CustomerEntity> createCustomer({
    required String name,
    required String mobile,
    required String email,
  });

  Future<CustomerResponseModel> manageCustomer(CustomerRequestModel requestModel);
}