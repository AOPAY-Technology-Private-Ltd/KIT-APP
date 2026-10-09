import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_enach_status_usecase.dart';
import 'enach_review_event.dart';
import 'enach_review_state.dart';

class EnachReviewBloc extends Bloc<EnachReviewEvent, EnachReviewState> {
  final UpdateEnachStatusUsecase updateEnachStatusUsecase;

  EnachReviewBloc({required this.updateEnachStatusUsecase}) : super(EnachReviewInitialState()) {
    on<SubmitEnachActionRequested>(_onSubmitEnachAction);
  }

  Future<void> _onSubmitEnachAction(
      SubmitEnachActionRequested event,
      Emitter<EnachReviewState> emit,
      ) async {
    emit(EnachReviewLoadingState());
    try {
      await updateEnachStatusUsecase(
        customerId: event.customerId,
        status: event.status,
        remarks: event.remarks,
      );
      emit(EnachReviewSuccessState('eNACH request ${event.status.toLowerCase()} successfully!'));
    } catch (e) {
      emit(EnachReviewErrorState(e.toString()));
    }
  }
}