import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<AuthEntity> call({
    required String mobile,
    required String otp,
  }) async {
    return await repository.verifyOtp(
      mobile: mobile,
      otp: otp,
    );
  }
}