import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_enach_requests_usecase.dart';
import 'enach_request_event.dart';
import 'enach_request_state.dart';

class EnachRequestBloc extends Bloc<EnachRequestEvent, EnachRequestState> {
  final GetEnachRequestsUsecase getEnachRequestsUsecase;

  EnachRequestBloc(this.getEnachRequestsUsecase) : super(EnachRequestInitialState()) {
    on<LoadEnachRequestsEvent>((event, emit) async {
      emit(EnachRequestLoadingState());
      try {
        final requests = await getEnachRequestsUsecase();
        emit(EnachRequestLoadedState(requests));
      } catch (e) {
        emit(EnachRequestErrorState(e.toString()));
      }
    });
  }
}