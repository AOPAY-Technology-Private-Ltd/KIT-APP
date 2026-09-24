import '../../domain/entities/home_entity.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final HomeEntity homeData;
  HomeLoadedState(this.homeData);
}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState(this.message);
}