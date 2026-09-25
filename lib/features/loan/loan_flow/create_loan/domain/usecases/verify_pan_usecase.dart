import '../repositories/create_loan_repository.dart';

class VerifyPanUseCase {
  final CreateLoanRepository repository;
  VerifyPanUseCase(this.repository);

  Future<bool> call(String panNumber) async {
    return await repository.verifyPan(panNumber);
  }
}