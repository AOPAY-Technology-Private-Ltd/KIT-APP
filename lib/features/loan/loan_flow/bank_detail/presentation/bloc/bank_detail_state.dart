abstract class BankDetailState {}

class BankDetailInitialState extends BankDetailState {}

class BankDetailLoadingState extends BankDetailState {}

class BankDetailSuccessState extends BankDetailState {}

class BankBankListLoadedState extends BankDetailState {
  final List<String> banks;
  BankBankListLoadedState(this.banks);
}

class AutoUpiUrlLoadedState extends BankDetailState {
  final String intentUrl;
  final String merchantOrderId;

  AutoUpiUrlLoadedState({
    required this.intentUrl,
    required this.merchantOrderId,
  });
}

class TransactionUrlLoadedState extends BankDetailState {
  final String intentUrl;
  final String merchantOrderId;

  TransactionUrlLoadedState({
    required this.intentUrl,
    required this.merchantOrderId,
  });
}

class BankDetailErrorState extends BankDetailState {
  final String error;
  BankDetailErrorState(this.error);
}