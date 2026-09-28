import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/emandate_entity.dart';
import '../../domain/usecases/submit_emandate_usecase.dart';
import 'emandate_event.dart';
import 'emandate_state.dart';

class EmandateBloc extends Bloc<EmandateEvent, EmandateState> {
  final SubmitEmandateUseCase submitEmandateUseCase;

  EmandateBloc(this.submitEmandateUseCase) : super(EmandateInitialState()) {
    on<SubmitEmandateEvent>(_onSubmitEmandate);
  }

  Future<void> _onSubmitEmandate(
      SubmitEmandateEvent event,
      Emitter<EmandateState> emit,
      ) async {
    emit(EmandateLoadingState());
    try {
      final entity = EmandateEntity(isAccepted: event.isAccepted);
      await submitEmandateUseCase(entity);
      emit(EmandateSuccessState());
    } catch (e) {
      emit(EmandateErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}