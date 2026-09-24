import 'dart:io';
import '../repositories/create_loan_repository.dart';

class SubmitDocumentsUseCase {
  final CreateLoanRepository repository;

  SubmitDocumentsUseCase(this.repository);

  Future<bool> call({
    required String dob,
    required String panNumber,
    required File panPhoto,
    required String aadhaarNumber,
    required File frontImage,
    required File backImage,
  }) async {
    return await repository.saveDocuments(
      dob: dob,
      panNumber: panNumber,
      panPhoto: panPhoto,
      aadhaarNumber: aadhaarNumber,
      frontImage: frontImage,
      backImage: backImage,
    );
  }
}