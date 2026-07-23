import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';
import '../models/verify_otp_request_model.dart';



abstract class AuthRemoteDatasource {


  Future<LoginResponseModel> sendOtp(
      String mobile
      );


  Future<LoginResponseModel> verifyOtp(
      VerifyOtpRequestModel request
      );


  Future<LoginResponseModel> signup(
      SignupRequestModel request
      );


}



class AuthRemoteDatasourceImpl
    implements AuthRemoteDatasource {



  @override
  Future<LoginResponseModel> sendOtp(
      String mobile
      ) async {


    await Future.delayed(
        const Duration(seconds:2)
    );


    return LoginResponseModel(
        message:"OTP Sent Successfully"
    );


  }




  @override
  Future<LoginResponseModel> verifyOtp(
      VerifyOtpRequestModel request
      ) async {


    await Future.delayed(
        const Duration(seconds:2)
    );


    return LoginResponseModel(

        message:"OTP Verified Successfully"

    );


  }





  @override
  Future<LoginResponseModel> signup(
      SignupRequestModel request
      ) async {


    await Future.delayed(
        const Duration(seconds:2)
    );


    return LoginResponseModel(
        message:"Account Created Successfully"
    );


  }


}