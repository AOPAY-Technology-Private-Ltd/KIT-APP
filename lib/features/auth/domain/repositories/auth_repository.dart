import '../entities/entities.dart';



abstract class AuthRepository {


  Future<AuthEntity> sendOtp(
      String mobile
      );

  Future<AuthEntity> verifyOtp({

    required String mobile,

    required String otp,

  });


  Future<AuthEntity> signup({

    required String businessName,

    required String businessType,

    String? gstType,

  });



}