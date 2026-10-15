import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/update_emi_repository.dart';
import 'update_emi_event.dart';
import 'update_emi_state.dart';

class UpdateEmiBloc extends Bloc<UpdateEmiEvent, UpdateEmiState> {
  final UpdateEmiRepository repository;

  UpdateEmiBloc(this.repository) : super(UpdateEmiInitial()) {
    on<FetchEmiDetailsEvent>(_onFetchEmiDetails);
    on<SubmitEmiEvent>(_onSubmitEmi);
  }

  Future<void> _onFetchEmiDetails(FetchEmiDetailsEvent event, Emitter<UpdateEmiState> emit) async {
    emit(UpdateEmiLoading());
    try {
      final details = await repository.fetchEmiDetails();
      emit(EmiDetailsLoadedState(emiDetails: details));
    } catch (e) {
      emit(UpdateEmiError(message: e.toString()));
    }
  }

  Future<void> _onSubmitEmi(SubmitEmiEvent event, Emitter<UpdateEmiState> emit) async {
    emit(UpdateEmiLoading());
    try {
      final success = await repository.submitUpdate(event.payload);
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