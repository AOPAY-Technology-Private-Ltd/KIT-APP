abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class OtpSentSuccess extends SignupState {
  final String message;

  OtpSentSuccess({
    required this.message,
  });
}

class SignupSuccess extends SignupState {

  final String message;

  SignupSuccess({
    required this.message,
  });

}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure({
    required this.error,
  });
}