import '../entities/entities.dart';
import '../repositories/auth_repository.dart';


class SignupUseCase {


  final AuthRepository repository;



  SignupUseCase(
      this.repository,
      );




  Future<AuthEntity> call({

    required String businessName,

    required String businessType,

    String? gstType,

  }) async {


    return await repository.signup(

      businessName: businessName,

      businessType: businessType,

      gstType: gstType,

    );


  }



}