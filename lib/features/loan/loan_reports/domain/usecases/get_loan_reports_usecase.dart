import '../entities/loan_report_entity.dart';
import '../repositories/loan_report_repository.dart';

class GetLoanReportsUseCase {
  final LoanReportRepository repository;

  GetLoanReportsUseCase(this.repository);

  Future<LoanReportSummaryEntity> call(String status) async {
    return await repository.getLoanReports(status);
  }
}