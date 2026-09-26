import 'dart:io';
import '../../domain/repositories/create_loan_repository.dart';
import '../datasources/basic_details_remote_data_source.dart';

class BasicDetailsRepositoryImpl implements BasicDetailsRepository {
  final BasicDetailsRemoteDataSource remoteDataSource;

  BasicDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> verifyPan(String panNumber) async {
    return await remoteDataSource.verifyPan(panNumber);
  }

  @override
  Future<bool> verifyAadhaar(String aadhaarNumber) async {
    return await remoteDataSource.verifyAadhaar(aadhaarNumber);
  }

  @override
  Future<bool> saveDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  }) async {
    return await remoteDataSource.uploadDocuments(
      dob: dob,
      panNumber: panNumber,
      panPhoto: panPhoto,
      aadhaarNumber: aadhaarNumber,
      frontImage: frontImage,
      backImage: backImage,
    );
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
    return await remoteDataSource.saveBasicDetails(
      customerPhoto: customerPhoto,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      alternateNumber: alternateNumber,
      emailId: emailId,
      address: address,
      acceptTerms: acceptTerms,
    );
  }
}