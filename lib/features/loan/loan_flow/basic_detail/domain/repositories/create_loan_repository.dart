import 'dart:io';

abstract class BasicDetailsRepository {
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

  Future<bool> saveBasicDetails({
    required File? customerPhoto,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String? alternateNumber,
    required String? emailId,
    required String? address,
    required bool acceptTerms,
  });
}