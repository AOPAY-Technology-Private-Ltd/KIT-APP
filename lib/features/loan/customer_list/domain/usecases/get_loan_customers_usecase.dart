import '../entities/loan_customer_entity.dart';
import '../repositories/loan_customer_repository.dart';

class GetLoanCustomersUseCase {
  final LoanCustomerRepository repository;

  GetLoanCustomersUseCase(this.repository);

  Future<List<LoanCustomerEntity>> call(String status) async {
    return await repository.getLoanCustomers(status);
  }
}