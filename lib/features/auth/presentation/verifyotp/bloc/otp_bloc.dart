import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final SendOtpUseCase sendOtpUseCase;

  OtpBloc({
    required this.verifyOtpUseCase,
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
      final response = await verifyOtpUseCase(
        mobile: event.mobileOrEmail,
        otp: event.otp,
      );

      emit(
        OtpSuccess(
          message: response.message,
        ),
      );
    } catch (e) {
      emit(
        OtpFailure(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _resendOtp(
      ResendOtpPressed event,
      Emitter<OtpState> emit,
      ) async {
    emit(OtpLoading());

    try {
      final response = await sendOtpUseCase(event.mobileOrEmail);

      emit(
        OtpSuccess(
          message: response.message,
        ),
      );
    } catch (e) {
      emit(
        OtpFailure(
          error: e.toString(),
        ),
      );
    }
  }
}