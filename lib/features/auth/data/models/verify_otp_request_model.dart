class VerifyOtpRequestModel {


  final String mobile;

  final String otp;



  VerifyOtpRequestModel({

    required this.mobile,

    required this.otp,

  });



  Map<String, dynamic> toJson() {

    return {

      "mobile": mobile,

      "otp": otp,

    };

  }


}