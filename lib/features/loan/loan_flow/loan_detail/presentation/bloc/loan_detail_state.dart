abstract class LoanDetailState {}

class LoanDetailInitialState extends LoanDetailState {}

class LoanDetailLoadingState extends LoanDetailState {}

class LoanDetailSuccessState extends LoanDetailState {}

class LoanDetailErrorState extends LoanDetailState {
  final String message;
  LoanDetailErrorState(this.message);
}