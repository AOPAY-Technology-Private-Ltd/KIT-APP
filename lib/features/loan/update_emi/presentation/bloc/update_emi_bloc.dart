import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_emi_update_usecase.dart';
import 'update_emi_event.dart';
import 'update_emi_state.dart';

class UpdateEmiBloc extends Bloc<UpdateEmiEvent, UpdateEmiState> {
  final UpdateEmiUseCase updateEmiUseCase;

  UpdateEmiBloc(this.updateEmiUseCase) : super(UpdateEmiInitial()) {
    on<SubmitEmiEvent>(_onSubmitEmi);
  }

  Future<void> _onSubmitEmi(SubmitEmiEvent event, Emitter<UpdateEmiState> emit) async {
    emit(UpdateEmiLoading());
    try {
      final success = await updateEmiUseCase(event.emiEntity);
      if (success) {
        emit(UpdateEmiSuccess(message: "EMI Updated Successfully!"));
      } else {
        emit(UpdateEmiError(message: "Failed to update EMI"));
      }
    } catch (e) {
      emit(UpdateEmiError(message: e.toString()));
    }
  }
}