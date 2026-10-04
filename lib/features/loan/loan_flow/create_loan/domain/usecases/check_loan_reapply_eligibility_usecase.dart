import '../repositories/create_loan_repository.dart';

class CheckLoanReapplyEligibilityUseCase {
  final CreateLoanRepository repository;

  CheckLoanReapplyEligibilityUseCase(this.repository);

  Future<String?> call({
    required String panNumber,
    required String aadhaarNumber,
  }) async {
    return await repository.checkLoanReapplyEligibility(
      panNumber: panNumber,
      aadhaarNumber: aadhaarNumber,
    );
  }
}