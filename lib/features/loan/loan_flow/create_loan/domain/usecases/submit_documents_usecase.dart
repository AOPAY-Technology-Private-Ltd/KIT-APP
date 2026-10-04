import 'dart:io';
import '../repositories/create_loan_repository.dart';

class SubmitDocumentsUseCase {
  final CreateLoanRepository repository;

  SubmitDocumentsUseCase(this.repository);

  Future<String?> call({
    required File? customerPhoto,
    required String dob,
    required String panNumber,
    required File? panPhoto,
    required String aadhaarNumber,
    required File? frontImage,
    required File? backImage,
    required String firstName,
    required String? lastName,
    required String? mobileNumber,
    required String emailId,
    String? primaryOtp,
    String? address,
    String? pinCode,
    String? stateName,
    String? cityName,
  }) async {
    return await repository.saveDocuments(
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
  }
}