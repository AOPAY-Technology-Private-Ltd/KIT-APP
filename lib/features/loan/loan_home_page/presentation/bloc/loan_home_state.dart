import '../../domain/entities/loan_home_entity.dart';

abstract class LoanHomeState {}

class HomeInitialState extends LoanHomeState {}

class HomeLoadingState extends LoanHomeState {}

class HomeLoadedState extends LoanHomeState {
  final LoanHomeEntity homeData;
  HomeLoadedState(this.homeData);
}

class HomeErrorState extends LoanHomeState {
  final String message;
  HomeErrorState(this.message);
}