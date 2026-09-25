import '../repositories/create_loan_repository.dart';

class VerifyAadhaarUseCase {
  final CreateLoanRepository repository;
  VerifyAadhaarUseCase(this.repository);

  Future<bool> call(String aadhaarNumber) async {
    return await repository.verifyAadhaar(aadhaarNumber);
  }
}