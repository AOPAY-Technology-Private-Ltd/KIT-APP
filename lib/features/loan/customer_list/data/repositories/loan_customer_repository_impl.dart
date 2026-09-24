import '../../domain/entities/loan_customer_entity.dart';
import '../../domain/repositories/loan_customer_repository.dart';
import '../datasources/loan_customer_remote_data_source.dart';
import '../models/loan_customer_model.dart';

class LoanCustomerRepositoryImpl implements LoanCustomerRepository {
  final LoanCustomerRemoteDataSource remoteDataSource;

  LoanCustomerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LoanCustomerEntity>> getLoanCustomers(String status) async {
    try {
      final List<LoanCustomerModel> remoteModels = await remoteDataSource.fetchLoanCustomers(status);
      return remoteModels;
    } catch (e) {
      throw Exception('Failed to fetch loan customers: $e');
    }
  }
}