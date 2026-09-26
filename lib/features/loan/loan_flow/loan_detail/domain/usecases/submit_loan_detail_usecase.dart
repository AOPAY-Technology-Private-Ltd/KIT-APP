import '../entities/loan_detail_entity.dart';
import '../repositories/loan_detail_repository.dart';

class SubmitLoanDetailUseCase {
  final LoanDetailRepository repository;

  SubmitLoanDetailUseCase(this.repository);

  Future<void> call(LoanDetailEntity loanDetail) async {
    return await repository.submitLoanDetail(loanDetail);
  }
}