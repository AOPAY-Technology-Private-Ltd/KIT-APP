import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_documents_usecase.dart';
import '../../domain/usecases/verify_pan_usecase.dart';
import '../../domain/usecases/verify_aadhaar_usecase.dart';
import '../../domain/usecases/get_credit_report_usecase.dart';
import '../../domain/usecases/check_loan_reapply_eligibility_usecase.dart';

import 'create_loan_event.dart';
import 'create_loan_state.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final SubmitDocumentsUseCase submitDocumentsUseCase;
  final VerifyPanUseCase verifyPanUseCase;
  final VerifyAadhaarUseCase verifyAadhaarUseCase;
  final GetCreditReportUseCase getCreditReportUseCase;
  final CheckLoanReapplyEligibilityUseCase checkLoanReapplyEligibilityUseCase;

  CreateLoanBloc({
    required this.submitDocumentsUseCase,
    required this.verifyPanUseCase,
    required this.verifyAadhaarUseCase,
    required this.getCreditReportUseCase,
    required this.checkLoanReapplyEligibilityUseCase,
  }) : super(const CreateLoanInitialState()) {

    on<VerifyPanEvent>((event, emit) async {
      try {
        final isValid = await verifyPanUseCase(event.panNumber);
        if (isValid) {
          emit(const PanVerifiedState());
        } else {
          emit(const CreateLoanErrorState('Invalid PAN Number verification failed'));
        }
      } catch (e) {
        emit(CreateLoanErrorState(e.toString()));
      }
    });

    on<VerifyAadhaarEvent>((event, emit) async {
      emit(const CreateLoanLoadingState());
      try {
        final result = await verifyAadhaarUseCase(
          event.aadhaarNumber,
          firstName: event.firstName,
          lastName: event.lastName,
          mobileNumber: event.mobileNumber,
        );

        if (result != null && result['kycUrl'] != null) {
          emit(
            AadhaarVerificationUrlReceivedState(
              kycUrl: result['kycUrl'].toString(),
              transactionId: result['transactionId']?.toString(),
            ),
          );
        } else {
          emit(const CreateLoanErrorState('Aadhaar verification URL not found'));
        }
      } catch (e) {
        emit(CreateLoanErrorState(e.toString()));
      }
    });

    on<GetCreditReportEvent>((event, emit) async {
      emit(const CreateLoanLoadingState());
      try {
        final reportData = await getCreditReportUseCase(
          firstName: event.firstName,
          lastName: event.lastName,
          mobileNumber: event.mobileNumber,
          dateOfBirth: event.dateOfBirth,
          emailId: event.emailId,
          panNumber: event.panNumber,
          otp: event.otp,
          consentMessage: event.consentMessage,
          consentAcceptance: event.consentAcceptance,
        );

        if (reportData != null) {
          debugPrint('=== Credit Report API Success (200). Now calling Eligibility API ===');

          await checkLoanReapplyEligibilityUseCase(
            panNumber: event.panNumber,
            aadhaarNumber: event.aadhaarNumber,
          );

          debugPrint('=== Eligibility API called. Now calling Submit Documents ===');

          final error = await submitDocumentsUseCase(
            customerPhoto: event.customerPhoto,
            dob: event.dateOfBirth,
            panNumber: event.panNumber,
            panPhoto: event.panPhoto,
            aadhaarNumber: event.aadhaarNumber,
            frontImage: event.frontImage,
            backImage: event.backImage,
            firstName: event.firstName,
            lastName: event.lastName,
            mobileNumber: event.mobileNumber,
            emailId: event.emailId,
            primaryOtp: event.primaryOtp ?? event.otp,
            address: event.address,
            pinCode: event.pinCode,
            stateName: event.stateName,
            cityName: event.cityName,
          );

          if (error == null) {
            emit(const DocumentsSubmittedSuccessState());
          } else {
            emit(CreateLoanErrorState(error));
          }
        } else {
          emit(const CreateLoanErrorState('Failed to fetch credit report'));
        }
      } catch (e) {
        emit(CreateLoanErrorState(e.toString()));
      }
    });

    on<SubmitDocumentsEvent>((event, emit) async {
      emit(const CreateLoanLoadingState());

      try {
        final error = await submitDocumentsUseCase(
          customerPhoto: event.customerPhoto,
          dob: event.dob,
          panNumber: event.panNumber ?? '',
          panPhoto: event.panPhoto,
          aadhaarNumber: event.aadhaarNumber ?? '',
          frontImage: event.frontImage,
          backImage: event.backImage,
          firstName: event.firstName,
          lastName: event.lastName,
          mobileNumber: event.mobileNumber,
          emailId: event.emailId ?? 'testuser@gmail.com',
          primaryOtp: event.primaryOtp,
          address: event.address,
          pinCode: event.pinCode,
          stateName: event.stateName,
          cityName: event.cityName,
        );

        if (error == null) {
          emit(const DocumentsSubmittedSuccessState());
        } else {
          emit(CreateLoanErrorState(error));
        }
      } catch (e) {
        debugPrint('=== SubmitDocumentsEvent Exception: $e ===');
        emit(CreateLoanErrorState(e.toString()));
      }
    });
  }
}