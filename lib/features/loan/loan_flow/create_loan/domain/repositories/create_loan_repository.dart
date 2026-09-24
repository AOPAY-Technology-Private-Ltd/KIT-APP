import 'dart:io';

abstract class CreateLoanRepository {
  Future<bool> verifyPan(String panNumber);
  Future<bool> verifyAadhaar(String aadhaarNumber);
  Future<bool> saveDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  });
}