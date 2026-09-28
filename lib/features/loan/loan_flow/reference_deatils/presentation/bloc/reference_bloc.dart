import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reference_entity.dart';
import '../../domain/usecases/submit_reference_usecase.dart';
import 'reference_event.dart';
import 'reference_state.dart';

class ReferenceBloc extends Bloc<ReferenceEvent, ReferenceState> {
  final SubmitReferenceUseCase submitReferenceUseCase;

  ReferenceBloc(this.submitReferenceUseCase) : super(ReferenceInitialState()) {
    on<SubmitReferenceEvent>((event, emit) async {
      emit(ReferenceLoadingState());
      try {
        final entity = ReferenceEntity(
          firstName: event.firstName,
          lastName: event.lastName,
          relationship: event.relationship,
          mobileNumber: event.mobileNumber,
          address: event.address,
        );

        await submitReferenceUseCase(entity);
        emit(ReferenceSuccessState());
      } catch (e) {
        emit(ReferenceErrorState(e.toString()));
      }
    });
  }
}