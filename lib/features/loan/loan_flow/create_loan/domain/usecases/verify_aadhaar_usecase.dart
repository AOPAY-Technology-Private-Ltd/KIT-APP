import '../repositories/create_loan_repository.dart';

class VerifyAadhaarUseCase {
  final CreateLoanRepository repository;

  VerifyAadhaarUseCase(
      this.repository,
      );

  Future<Map<String, dynamic>?> call(
      String aadhaarNumber, {
        required String firstName,
        String? lastName,
        String? mobileNumber,
      }) async {
    return await repository.verifyAadhaar(
      aadhaarNumber,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
    );
  }
}