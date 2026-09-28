abstract class EmandateState {}

class EmandateInitialState extends EmandateState {}

class EmandateLoadingState extends EmandateState {}

class EmandateSuccessState extends EmandateState {}

class EmandateErrorState extends EmandateState {
  final String message;

  EmandateErrorState(this.message);
}