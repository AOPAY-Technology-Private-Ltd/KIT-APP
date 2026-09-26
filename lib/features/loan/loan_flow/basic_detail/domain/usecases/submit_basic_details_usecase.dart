import 'dart:io';
import '../repositories/create_loan_repository.dart';

class SubmitBasicDetailsUseCase {
  final BasicDetailsRepository repository;

  SubmitBasicDetailsUseCase(this.repository);

  Future<bool> call({
    required File? customerPhoto,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String? alternateNumber,
    required String? emailId,
    required String? address,
    required bool acceptTerms,
  }) async {
    return await repository.saveBasicDetails(
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