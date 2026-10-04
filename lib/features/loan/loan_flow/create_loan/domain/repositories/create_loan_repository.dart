import 'dart:io';

abstract class CreateLoanRepository {
  Future<bool> verifyPan(String panNumber);

  Future<Map<String, dynamic>?> verifyAadhaar(
      String aadhaarNumber, {
        required String firstName,
        String? lastName,
        String? mobileNumber,
        String? emailId,
      });

  Future<Map<String, dynamic>?> fetchAadhaarTransaction(String transactionId);

  Future<String?> checkLoanReapplyEligibility({
    required String panNumber,
    required String aadhaarNumber,
  });

  Future<Map<String, dynamic>?> getCreditReport({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String dateOfBirth,
    required String emailId,
    required String panNumber,
    required String otp,
    required String consentMessage,
    required String consentAcceptance,
  });

  Future<String?> saveDocuments({
    required File? customerPhoto,
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
    required String firstName,
    String? lastName,
    String? mobileNumber,
    String? emailId,
    String? primaryOtp,
    String? address,
    String? pinCode,
    String? stateName,
    String? cityName,
  });
}