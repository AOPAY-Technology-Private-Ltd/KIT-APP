import 'dart:io';

abstract class BasicDetailsRemoteDataSource {
  Future<bool> verifyPan(String panNumber);
  Future<bool> verifyAadhaar(String aadhaarNumber);
  Future<bool> uploadDocuments({
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

class BasicDetailsRemoteDataSourceImpl implements BasicDetailsRemoteDataSource {
  @override
  Future<bool> verifyPan(String panNumber) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return panNumber.length == 10;
    } catch (e) {
      throw Exception('PAN Verification Error: $e');
    }
  }

  @override
  Future<bool> verifyAadhaar(String aadhaarNumber) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return aadhaarNumber.length == 12;
    } catch (e) {
      throw Exception('Verification Error: $e');
    }
  }

  @override
  Future<bool> uploadDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Remote Data Source Error: $e');
    }
  }

  @override
  Future<bool> saveBasicDetails({
    required File? customerPhoto,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String? alternateNumber,
    required String? emailId,
    required String? address,
    required bool acceptTerms,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      throw Exception('Remote Data Source Error: $e');
    }
  }
}