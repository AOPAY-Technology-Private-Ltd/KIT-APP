import '../entities/entities.dart';

abstract class AuthRepository {

  Future<AuthEntity> login({
    required String mobileOrEmailID,
  });
  Future<AuthEntity> sendOtp(String mobile);

  Future<AuthEntity> verifyOtp({
    required String mobile,
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