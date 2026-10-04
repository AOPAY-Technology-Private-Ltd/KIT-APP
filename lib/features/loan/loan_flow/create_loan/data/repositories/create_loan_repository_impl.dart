import 'dart:io';

import '../../domain/repositories/create_loan_repository.dart';
import '../datasources/create_loan_remote_data_source.dart';

class CreateLoanRepositoryImpl implements CreateLoanRepository {
  final CreateLoanRemoteDataSource remoteDataSource;

  CreateLoanRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<bool> verifyPan(String panNumber) async {
    return await remoteDataSource.verifyPan(panNumber);
  }

  @override
  Future<Map<String, dynamic>?> verifyAadhaar(
      String aadhaarNumber, {
        required String firstName,
        String? lastName,
        String? mobileNumber,
        String? emailId,
      }) async {
    return await remoteDataSource.verifyAadhaar(
      aadhaarNumber,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      emailId: emailId,
    );
  }

  @override
  Future<Map<String, dynamic>?> fetchAadhaarTransaction(
      String transactionId,
      ) async {
    return await remoteDataSource.fetchAadhaarTransaction(transactionId);
  }

  @override
  Future<String?> checkLoanReapplyEligibility({
    required String panNumber,
    required String aadhaarNumber,
  }) async {
    return await remoteDataSource.checkLoanReapplyEligibility(
      panNumber: panNumber,
      aadhaarNumber: aadhaarNumber,
    );
  }

  @override
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
  }) async {
    return await remoteDataSource.getCreditReport(
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

  @override
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
  }) async {
    final errorMessage = await remoteDataSource.uploadDocuments(
      customerPhoto: customerPhoto,
      dob: dob,
      panNumber: panNumber,
      panPhoto: panPhoto,
      aadhaarNumber: aadhaarNumber,
      frontImage: frontImage,
      backImage: backImage,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      emailId: emailId,
      primaryOtp: primaryOtp,
      address: address,
      pinCode: pinCode,
      stateName: stateName,
      cityName: cityName,
    );

    return errorMessage;
  }
}