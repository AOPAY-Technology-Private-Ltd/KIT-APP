import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/loan_get_home_data_usecase.dart';
import 'loan_home_event.dart';
import 'loan_home_state.dart';

class LoanHomeBloc extends Bloc<LoanHomeEvent, LoanHomeState> {
  final GetLoanHomeDataUseCase getHomeDataUseCase;

  LoanHomeBloc({required this.getHomeDataUseCase}) : super(HomeInitialState()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoadingState());
      try {
        final homeData = await getHomeDataUseCase();
        emit(HomeLoadedState(homeData));
      } catch (e) {
        emit(HomeErrorState(e.toString()));
      }
    });
  }
}