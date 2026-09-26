import '../entities/loan_detail_entity.dart';

abstract class LoanDetailRepository {
  Future<void> submitLoanDetail(LoanDetailEntity loanDetail);
}