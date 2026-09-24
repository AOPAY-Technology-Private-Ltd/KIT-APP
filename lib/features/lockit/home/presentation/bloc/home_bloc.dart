import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({required this.getHomeDataUseCase}) : super(HomeInitialState()) {
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