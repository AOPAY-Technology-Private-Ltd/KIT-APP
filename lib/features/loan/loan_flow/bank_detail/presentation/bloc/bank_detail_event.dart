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