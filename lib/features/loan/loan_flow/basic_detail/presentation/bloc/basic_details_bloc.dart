import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/basic_loan_repository.dart';
import '../../domain/usecases/submit_basic_details_usecase.dart';
import 'basic_details_event.dart';
import 'basic_details_state.dart';

class BasicDetailsBloc extends Bloc<BasicDetailsEvent, BasicDetailsState> {
  final SubmitBasicDetailsUseCase submitBasicDetailsUseCase;
  final BasicDetailsRepository repository;

  BasicDetailsBloc({
    required this.submitBasicDetailsUseCase,
    required this.repository,
  }) : super(BasicDetailsInitialState()) {

    on<SendOtpEvent>((event, emit) async {
      debugPrint('--- BLoC: SendOtpEvent Received ---');
      emit(BasicDetailsLoadingState());
      try {
        bool otpSent = await repository.sendOtp(
          mobileOrEmailID: event.mobileNumber,
          otpType: 'Customer',
        );

        if (otpSent) {
          debugPrint('--- BLoC: OtpSentSuccessState Emitted ---');
          emit(OtpSentSuccessState());
        } else {
          emit(const BasicDetailsErrorState('Failed to send OTP'));
        }
      } catch (e) {
        emit(BasicDetailsErrorState(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      debugPrint('--- BLoC: VerifyOtpEvent Received ---');
      emit(BasicDetailsLoadingState());
      try {
        String? errorMessage = await repository.verifyOtp(
          mobileOrEmail: event.mobileNumber,
          enteredOTP: event.otp,
        );

        if (errorMessage != null) {
          emit(BasicDetailsErrorState(errorMessage));
        } else {
          debugPrint('--- BLoC: OtpVerifiedSuccessState Emitted ---');
          emit(const OtpVerifiedSuccessState('OTP verified successfully!'));
        }
      } catch (e) {
        emit(BasicDetailsErrorState(e.toString()));
      }
    });

    on<SubmitBasicDetailsEvent>((event, emit) async {
      debugPrint('--- BLoC: SubmitBasicDetailsEvent Received ---');
      emit(BasicDetailsLoadingState());
      try {
        final result = await submitBasicDetailsUseCase(
          customerPhoto: event.customerPhoto,
          firstName: event.firstName,
          lastName: event.lastName,
          mobileNumber: event.mobileNumber,
          alternateNumber: event.alternateNumber,
          emailId: event.emailId,
          address: event.address,
          acceptTerms: event.acceptTerms,
        );

        if (result) {
          debugPrint('--- BLoC: BasicDetailsSubmittedSuccessState Emitted ---');
          emit(BasicDetailsSubmittedSuccessState());
        } else {
          emit(const BasicDetailsErrorState('Failed to save basic details'));
        }
      } catch (e) {
        emit(BasicDetailsErrorState(e.toString()));
      }
    });
  }
}