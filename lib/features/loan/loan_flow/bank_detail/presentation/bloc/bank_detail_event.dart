import '../../domain/entities/bank_detail_entity.dart';

abstract class BankDetailEvent {}

class SubmitBankDetailEvent extends BankDetailEvent {
  final BankDetailEntity entity;
  SubmitBankDetailEvent(this.entity);
}

class FetchBankListEvent extends BankDetailEvent {
  final String registrationId;
  FetchBankListEvent(this.registrationId);
}

class SetupAutoUpiEvent extends BankDetailEvent {
  final String registrationId;
  SetupAutoUpiEvent(this.registrationId);
}

class VerifyAndPostTransactionEvent extends BankDetailEvent {
  final String registrationId;
  final String loanCode;
  final String emiNumbers;

  VerifyAndPostTransactionEvent({
    required this.registrationId,
    required this.loanCode,
    required this.emiNumbers,
  });
}

class CheckOrderAndStepFourEvent extends BankDetailEvent {
  final String registrationId;
  final String merchantOrderId;

  CheckOrderAndStepFourEvent({
    required this.registrationId,
    required this.merchantOrderId,
  });
}