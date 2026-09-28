abstract class TermsState {}

class TermsInitialState extends TermsState {}

class TermsLoadingState extends TermsState {}

class TermsSuccessState extends TermsState {
  final String message;
  TermsSuccessState(this.message);
}

class TermsErrorState extends TermsState {
  final String message;
  TermsErrorState(this.message);
}