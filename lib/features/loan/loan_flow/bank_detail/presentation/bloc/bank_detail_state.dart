import '../../domain/entities/bank_detail_entity.dart';

abstract class BankDetailState {}

class BankDetailInitialState extends BankDetailState {}

class BankDetailLoadingState extends BankDetailState {}

class BankDetailSuccessState extends BankDetailState {}

class BankBankListLoadedState extends BankDetailState {
  final List<String> banks;
  BankBankListLoadedState(this.banks);
}

class BankDetailErrorState extends BankDetailState {
  final String message;
  BankDetailErrorState(this.message);
}