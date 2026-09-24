import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<AuthEntity> call({
    required String businessName,
    required String businessType,
    String? gstNumber,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String emailID,
  }) async {
    return await repository.signup(
      businessName: businessName,
      businessType: businessType,
      gstNumber: gstNumber,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      emailID: emailID,
    );
  }
}