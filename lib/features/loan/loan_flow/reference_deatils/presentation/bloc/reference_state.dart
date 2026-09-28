abstract class ReferenceState {}

class ReferenceInitialState extends ReferenceState {}
class ReferenceLoadingState extends ReferenceState {}
class ReferenceSuccessState extends ReferenceState {}
class ReferenceErrorState extends ReferenceState {
  final String message;
  ReferenceErrorState(this.message);
}