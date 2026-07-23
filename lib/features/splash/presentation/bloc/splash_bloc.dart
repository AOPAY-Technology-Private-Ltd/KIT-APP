
import 'splash_event.dart';
import 'splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SplashBloc
    extends Bloc<SplashEvent,SplashState>{


  SplashBloc()
      : super(SplashInitial()){


    on<SplashStarted>(_start);


  }



  Future<void> _start(

      SplashStarted event,

      Emitter<SplashState> emit,

      ) async {


    emit(
      SplashLoading(),
    );



    await Future.delayed(

      const Duration(seconds:3),

    );



    emit(

      SplashCompleted(
        isLoggedIn:false,
      ),

    );


  }



}