import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class CreateCustomerUseCase {
  final CustomerRepository repository;

  CreateCustomerUseCase(this.repository);

  Future<CustomerEntity> call({
    required String name,
    required String mobile,
    required String email,
  }) async {
    return await repository.createCustomer(
      name: name,
      mobile: mobile,
      email: email,
    );
  }
}