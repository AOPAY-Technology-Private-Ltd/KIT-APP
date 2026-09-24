import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/signup_usecase.dart';
import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../data/datasource/auth_remote_datasource.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final AuthRemoteDatasource authRemoteDatasource;

  SignupBloc({
    required this.signupUseCase,
    required this.sendOtpUseCase,
    required this.authRemoteDatasource,
  }) : super(SignupInitial()) {
    on<SignupSubmitted>(_signup);
    on<SendOtpRequested>(_sendOtp);
  }

  Future<void> _sendOtp(
      SendOtpRequested event,
      Emitter<SignupState> emit,
      ) async {
    try {
      emit(SignupLoading());
      final response = await sendOtpUseCase(event.mobileOrEmailID);

      emit(
        OtpSentSuccess(
          message: response.message,
        ),
      );
    } catch (e) {
      String rawError = e.toString().replaceAll("Exception: ", "");

      String errorMessage;
      if (rawError.contains('No internet connection') ||
          rawError.contains('SocketException') ||
          rawError.contains('Failed host lookup')) {
        errorMessage = 'No internet connection. Please check your network settings.';
      } else {
        errorMessage = rawError;
      }

      emit(SignupFailure(error: errorMessage));
    }
  }

  Future<void> _signup(
      SignupSubmitted event,
      Emitter<SignupState> emit,
      ) async {

    try {

      emit(SignupLoading());


      print("------ SIGNUP BLOC START ------");


      final response = await signupUseCase(

        businessName: event.businessName,

        businessType: event.businessType,

        gstNumber: event.gstNumber ?? "",

        firstName: event.firstName,

        lastName: event.lastName,

        mobileNumber: event.mobile,

        emailID: event.email,

      );


      print(
        "SIGNUP SUCCESS MESSAGE : ${response.message}",
      );


      emit(
        SignupSuccess(
          message: response.message,
        ),
      );


      print("SIGNUP SUCCESS EMITTED");


    } catch(e){


      print(
        "SIGNUP ERROR : $e",
      );

      String rawError = e.toString().replaceAll("Exception: ", "");

      String errorMessage;
      if (rawError.contains('No internet connection') ||
          rawError.contains('SocketException') ||
          rawError.contains('Failed host lookup')) {
        errorMessage = 'No internet connection. Please check your network settings.';
      } else {
        errorMessage = rawError;
      }


      emit(
        SignupFailure(
          error: errorMessage,
        ),
      );

    }

  }
}