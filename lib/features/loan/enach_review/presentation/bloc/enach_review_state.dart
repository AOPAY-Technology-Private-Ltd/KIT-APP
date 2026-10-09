abstract class EnachReviewState {}

class EnachReviewInitialState extends EnachReviewState {}

class EnachReviewLoadingState extends EnachReviewState {}

class EnachReviewSuccessState extends EnachReviewState {
  final String message;
  EnachReviewSuccessState(this.message);
}

class EnachReviewErrorState extends EnachReviewState {
  final String message;
  EnachReviewErrorState(this.message);
}