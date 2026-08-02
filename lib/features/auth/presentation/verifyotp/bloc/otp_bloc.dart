import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import '../../../domain/usecases/kit_verify_otp_usecase.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final KitVerifyOtpUseCase kitVerifyOtpUseCase;
  final SendOtpUseCase sendOtpUseCase;

  OtpBloc({
    required this.verifyOtpUseCase,
    required this.kitVerifyOtpUseCase,
    required this.sendOtpUseCase,
  }) : super(OtpInitial()) {
    on<VerifyOtpPressed>(_verifyOtp);
    on<ResendOtpPressed>(_resendOtp);
  }

  Future<void> _verifyOtp(
      VerifyOtpPressed event,
      Emitter<OtpState> emit,
      ) async {
    emit(OtpLoading());

    try {
      final response;

      if (event.isLogin) {
        response = await kitVerifyOtpUseCase(
          mobileOrEmail: event.mobileOrEmail,
          otp: event.otp,
        );
      } else {
        response = await verifyOtpUseCase(
          mobileOrEmail: event.mobileOrEmail,
          otp: event.otp,
        );
      }

      emit(
        OtpSuccess(
          message: response.message,
        ),
      );
    } catch (e) {
      String error = e.toString();
      if (error.startsWith("Exception: ")) {
        error = error.replaceFirst("Exception: ", "");
      }
      emit(
        OtpFailure(
          error: error,
        ),
      );
    }
  }

  Future<void> _resendOtp(ResendOtpPressed event, Emitter<OtpState> emit) async {
  }
}