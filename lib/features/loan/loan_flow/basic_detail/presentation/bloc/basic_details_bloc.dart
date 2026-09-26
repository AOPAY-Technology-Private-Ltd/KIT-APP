import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_basic_details_usecase.dart';
import 'basic_details_event.dart';
import 'basic_details_state.dart';

class BasicDetailsBloc extends Bloc<BasicDetailsEvent, BasicDetailsState> {
  final SubmitBasicDetailsUseCase submitBasicDetailsUseCase;

  BasicDetailsBloc({
    required this.submitBasicDetailsUseCase,
  }) : super(BasicDetailsInitialState()) {

    on<SubmitBasicDetailsEvent>((event, emit) async {
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
          emit(BasicDetailsSubmittedSuccessState());
        } else {
          emit(BasicDetailsErrorState('Failed to save basic details'));
        }
      } catch (e) {
        emit(BasicDetailsErrorState(e.toString()));
      }
    });
  }
}