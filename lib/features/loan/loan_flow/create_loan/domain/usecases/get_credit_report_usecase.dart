import '../repositories/create_loan_repository.dart';

class GetCreditReportUseCase {
  final CreateLoanRepository repository;

  GetCreditReportUseCase(this.repository);

  Future<Map<String, dynamic>?> call({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String dateOfBirth,
    required String emailId,
    required String panNumber,
    required String otp,
    required String consentMessage,
    required String consentAcceptance,
  }) async {
    return await repository.getCreditReport(
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      dateOfBirth: dateOfBirth,
      emailId: emailId,
      panNumber: panNumber,
      otp: otp,
      consentMessage: consentMessage,
      consentAcceptance: consentAcceptance,
    );
  }
}