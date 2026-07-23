import '../../domain/entities/entities.dart';


class LoginResponseModel extends AuthEntity {


  LoginResponseModel({

    required super.message,

  });





  factory LoginResponseModel.fromJson(

      Map<String, dynamic> json

      ) {


    return LoginResponseModel(

      message:
      json['message'] ?? "",

    );


  }





  Map<String, dynamic> toJson() {


    return {


      "message":
      message,


    };


  }



}