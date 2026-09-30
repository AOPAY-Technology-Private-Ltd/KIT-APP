import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_documents_usecase.dart';
import '../../domain/usecases/verify_pan_usecase.dart';
import '../../domain/usecases/verify_aadhaar_usecase.dart';

import 'create_loan_event.dart';
import 'create_loan_state.dart';

class CreateLoanBloc
    extends Bloc<CreateLoanEvent, CreateLoanState> {
  final SubmitDocumentsUseCase submitDocumentsUseCase;
  final VerifyPanUseCase verifyPanUseCase;
  final VerifyAadhaarUseCase verifyAadhaarUseCase;

  CreateLoanBloc({
    required this.submitDocumentsUseCase,
    required this.verifyPanUseCase,
    required this.verifyAadhaarUseCase,
  }) : super(
    const CreateLoanInitialState(),
  ) {


    on<VerifyPanEvent>((event, emit) async {
      try {
        final isValid =
        await verifyPanUseCase(event.panNumber);

        if (isValid) {
          emit(
            const PanVerifiedState(),
          );
        } else {
          emit(
            const CreateLoanErrorState(
              'Invalid PAN Number verification failed',
            ),
          );
        }
      } catch (e) {
        emit(
          CreateLoanErrorState(
            e.toString(),
          ),
        );
      }
    });

    on<VerifyAadhaarEvent>((event, emit) async {
      emit(
        const CreateLoanLoadingState(),
      );

      try {
        final result =
        await verifyAadhaarUseCase(
          event.aadhaarNumber,
          firstName: event.firstName,
          lastName: event.lastName,
        );

        if (result != null &&
            result['kycUrl'] != null) {

          print(
            '=== Aadhaar Complete Flow Response ===',
          );

          print(
            'KYC URL: ${result['kycUrl']}',
          );

          print(
            'Transaction ID: ${result['transactionId']}',
          );

          print(
            'Transaction Response: '
                '${result['transactionResponse']}',
          );

          emit(
            AadhaarVerificationUrlReceivedState(
              kycUrl: result['kycUrl'].toString(),
              transactionId:
              result['transactionId']?.toString(),
            ),
          );
        } else {
          emit(
            const CreateLoanErrorState(
              'Aadhaar verification URL not found',
            ),
          );
        }
      } catch (e) {
        emit(
          CreateLoanErrorState(
            e.toString(),
          ),
        );
      }
    });

    on<SubmitDocumentsEvent>((event, emit) async {
      emit(
        const CreateLoanLoadingState(),
      );

      try {
        final result =
        await submitDocumentsUseCase(
          dob: event.dob,
          panNumber: event.panNumber ?? '',
          panPhoto: event.panPhoto,
          aadhaarNumber:
          event.aadhaarNumber ?? '',
          frontImage: event.frontImage,
          backImage: event.backImage,
        );

        if (result) {
          emit(
            const DocumentsSubmittedSuccessState(),
          );
        } else {
          emit(
            const CreateLoanErrorState(
              'Failed to save documents',
            ),
          );
        }
      } catch (e) {
        emit(
          CreateLoanErrorState(
            e.toString(),
          ),
        );
      }
    });
  }
}