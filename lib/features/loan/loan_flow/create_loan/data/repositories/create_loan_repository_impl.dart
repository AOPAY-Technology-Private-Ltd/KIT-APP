import 'dart:io';
import '../../domain/repositories/create_loan_repository.dart';
import '../datasources/create_loan_remote_data_source.dart';

class CreateLoanRepositoryImpl implements CreateLoanRepository {
  final CreateLoanRemoteDataSource remoteDataSource;

  CreateLoanRepositoryImpl({required this.remoteDataSource});

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
}