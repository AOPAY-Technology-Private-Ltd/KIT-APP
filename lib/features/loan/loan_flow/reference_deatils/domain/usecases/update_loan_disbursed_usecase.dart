import '../../data/repositories/loan_disbursed_repository.dart';

class UpdateLoanDisbursedUseCase {
  final LoanDisbursedRepository repository;

  UpdateLoanDisbursedUseCase(this.repository);

  Future<void> call() async {
    return await repository.updateLoanDisbursedStep();
  }
}