class SignupRequestModel {


  final String businessName;

  final String businessType;

  final String? gstType;



  SignupRequestModel({


    required this.businessName,


    required this.businessType,


    this.gstType,


  });





  Map<String, dynamic> toJson() {


    return {


      "business_name":
      businessName,


      "business_type":
      businessType,


      "gst_type":
      gstType,


    };


  }



}