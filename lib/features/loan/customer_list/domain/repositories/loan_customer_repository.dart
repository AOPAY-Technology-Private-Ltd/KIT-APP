import '../entities/loan_customer_entity.dart';

abstract class LoanCustomerRepository {
  Future<List<LoanCustomerEntity>> getLoanCustomers(String status);
}