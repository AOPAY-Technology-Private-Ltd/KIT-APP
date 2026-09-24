import '../entities/entities.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({
    required String mobileOrEmailID,
  });

  Future<AuthEntity> sendOtp(String mobile);

  Future<AuthEntity> kitVerifyOtp({
    required String mobileOrEmail,
    required String otp,
  });

  Future<AuthEntity> verifyOtp({
    required String mobileOrEmail,
    required String otp,
  });

  Future<AuthEntity> signup({
    required String businessName,
    required String businessType,
    String? gstNumber,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String emailID,
  });
}