import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/signup_usecase.dart';

import 'signup_event.dart';
import 'signup_state.dart';



class SignupBloc
    extends Bloc<SignupEvent, SignupState> {


  final SignupUseCase signupUseCase;



  SignupBloc({

    required this.signupUseCase,

  }) : super(SignupInitial()) {



    on<SignupSubmitted>(_signup);


  }







  Future<void> _signup(

      SignupSubmitted event,

      Emitter<SignupState> emit,

      ) async {


    try {


      emit(

        SignupLoading(),

      );





      final response =

      await signupUseCase(

        businessName:
        event.businessName,


        businessType:
        event.businessType,


        gstType:
        event.gstType,


      );







      emit(

        SignupSuccess(

          message:
          response.message,

        ),

      );





    }

    catch(e){



      emit(

        SignupFailure(

          error:
          e.toString(),

        ),

      );


    }


  }



}