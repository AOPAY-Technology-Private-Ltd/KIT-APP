import '../../data/models/customer_request_model.dart';
import '../../data/models/customer_response_model.dart';
import '../repositories/customer_repository.dart';

class ManageCustomerUseCase {
  final CustomerRepository repository;

  ManageCustomerUseCase(this.repository);

  Future<CustomerResponseModel> call(CustomerRequestModel requestModel) async {
    return await repository.manageCustomer(requestModel);
  }
}