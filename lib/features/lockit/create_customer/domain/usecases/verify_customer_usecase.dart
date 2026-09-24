import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class VerifyCustomerUseCase {
  final CustomerRepository repository;

  VerifyCustomerUseCase(this.repository);

  Future<CustomerEntity> call({required String primaryMobileNumber}) async {
    return await repository.verifyCustomerKit(primaryMobileNumber: primaryMobileNumber);
  }
}