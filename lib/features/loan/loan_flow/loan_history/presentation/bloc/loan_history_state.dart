import '../../domain/entities/loan_portfolio_entity.dart';

abstract class LoanHistoryState {}

class LoanHistoryInitialState extends LoanHistoryState {}

class LoanHistoryLoadingState extends LoanHistoryState {}

class LoanHistoryLoadedState extends LoanHistoryState {
  final LoanPortfolioEntity portfolio;
  LoanHistoryLoadedState({required this.portfolio});
}

class LoanHistoryErrorState extends LoanHistoryState {
  final String message;
  LoanHistoryErrorState({required this.message});
}