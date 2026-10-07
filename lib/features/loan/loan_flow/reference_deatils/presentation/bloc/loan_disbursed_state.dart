abstract class LoanDisbursedState {}

class LoanDisbursedInitial extends LoanDisbursedState {}

class LoanDisbursedLoading extends LoanDisbursedState {}

class LoanDisbursedSuccess extends LoanDisbursedState {}

class LoanDisbursedError extends LoanDisbursedState {
  final String message;
  LoanDisbursedError(this.message);
}