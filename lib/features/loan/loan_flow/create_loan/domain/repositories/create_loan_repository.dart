import 'dart:io';

abstract class CreateLoanRepository {
  Future<bool> verifyPan(
      String panNumber,
      );

  Future<Map<String, dynamic>?> verifyAadhaar(
      String aadhaarNumber, {
        required String firstName,
        String? lastName,
      });

  Future<Map<String, dynamic>?> fetchAadhaarTransaction(
      String transactionId,
      );

  Future<bool> saveDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  });
}