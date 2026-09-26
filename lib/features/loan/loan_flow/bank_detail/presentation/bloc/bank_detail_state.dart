abstract class BankDetailState {}

class BankDetailInitialState extends BankDetailState {}

class BankDetailLoadingState extends BankDetailState {}

class BankDetailSuccessState extends BankDetailState {}

class BankDetailErrorState extends BankDetailState {
  final String message;
  BankDetailErrorState(this.message);
}