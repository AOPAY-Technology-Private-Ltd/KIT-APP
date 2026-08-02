import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

class KitVerifyOtpUseCase {
  final AuthRepository repository;

  KitVerifyOtpUseCase(this.repository);

  Future<AuthEntity> call({
    required String mobileOrEmail,
    required String otp,
  }) async {
    return await repository.kitVerifyOtp(
      mobileOrEmail: mobileOrEmail,
      otp: otp,
    );
  }
}