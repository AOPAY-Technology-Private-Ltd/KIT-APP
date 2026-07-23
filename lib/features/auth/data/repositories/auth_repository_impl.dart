import '../../domain/entities/entities.dart';
import '../../domain/repositories/auth_repository.dart';

import '../datasource/auth_remote_datasource.dart';

import '../models/signup_request_model.dart';
import '../models/verify_otp_request_model.dart';



class AuthRepositoryImpl
    implements AuthRepository {



  final AuthRemoteDatasource datasource;



  AuthRepositoryImpl({

    required this.datasource

  });





  @override
  Future<AuthEntity> sendOtp(
      String mobile
      ) async {


    return await datasource.sendOtp(
        mobile
    );


  }





  @override
  Future<AuthEntity> verifyOtp({

    required String mobile,

    required String otp,

  }) async {



    final request =
    VerifyOtpRequestModel(

      mobile: mobile,

      otp: otp,

    );



    return await datasource.verifyOtp(
        request
    );


  }






  @override
  Future<AuthEntity> signup({

    required String businessName,

    required String businessType,

    String? gstType,

  }) async {



    final request =
    SignupRequestModel(

      businessName: businessName,

      businessType: businessType,

      gstType: gstType,

    );



    return await datasource.signup(
        request
    );


  }



}