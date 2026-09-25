import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_documents_usecase.dart';
import '../../domain/usecases/verify_pan_usecase.dart';
import '../../domain/usecases/verify_aadhaar_usecase.dart';
import 'create_loan_event.dart';
import 'create_loan_state.dart';

class CreateLoanBloc extends Bloc<CreateLoanEvent, CreateLoanState> {
  final SubmitDocumentsUseCase submitDocumentsUseCase;
  final VerifyPanUseCase verifyPanUseCase;
  final VerifyAadhaarUseCase verifyAadhaarUseCase;

  CreateLoanBloc({
    required this.submitDocumentsUseCase,
    required this.verifyPanUseCase,
    required this.verifyAadhaarUseCase,
  }) : super(CreateLoanInitialState()) {

    on<VerifyPanEvent>((event, emit) async {
      try {
        final isValid = await verifyPanUseCase(event.panNumber);
        if (isValid) {
          emit(PanVerifiedState());
        } else {
          emit(CreateLoanErrorState('Invalid PAN Number verification failed'));
        }
      } catch (e) {
        emit(CreateLoanErrorState(e.toString()));
      }
    });

    on<VerifyAadhaarEvent>((event, emit) async {
      try {
        final isValid = await verifyAadhaarUseCase(event.aadhaarNumber);
        if (isValid) {
          emit(AadhaarVerifiedState());
        } else {
          emit(CreateLoanErrorState('Invalid Aadhaar Number verification failed'));
        }
      } catch (e) {
        emit(CreateLoanErrorState(e.toString()));
      }
    });

    on<SubmitDocumentsEvent>((event, emit) async {
      emit(CreateLoanLoadingState());
      try {
        final result = await submitDocumentsUseCase(
          dob: event.dob,
          panNumber: event.panNumber ?? '',
          panPhoto: event.panPhoto!,
          aadhaarNumber: event.aadhaarNumber ?? '',
          frontImage: event.frontImage!,
          backImage: event.backImage!,
        );

        if (result) {
          emit(DocumentsSubmittedSuccessState());
        } else {
          emit(CreateLoanErrorState('Failed to save documents'));
        }
      } catch (e) {
        emit(CreateLoanErrorState(e.toString()));
      }
    });
  }
}