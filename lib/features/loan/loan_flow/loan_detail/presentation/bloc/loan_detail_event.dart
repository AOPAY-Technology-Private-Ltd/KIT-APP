import '../../domain/entities/loan_detail_entity.dart';

abstract class LoanDetailEvent {}

class SubmitLoanDetailEvent extends LoanDetailEvent {
  final LoanDetailEntity loanDetail;
  SubmitLoanDetailEvent(this.loanDetail);
}