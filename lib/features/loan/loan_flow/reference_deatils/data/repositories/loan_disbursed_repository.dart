import '../datasources/loan_disbursed_remote_data_source.dart';

abstract class LoanDisbursedRepository {
  Future<void> updateLoanDisbursedStep();
}

class LoanDisbursedRepositoryImpl implements LoanDisbursedRepository {
  final LoanDisbursedRemoteDataSource remoteDataSource;

  LoanDisbursedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> updateLoanDisbursedStep() async {
    await remoteDataSource.updateLoanDisbursedStep();
  }
}