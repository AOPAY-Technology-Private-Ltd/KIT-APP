import '../entities/loan_report_entity.dart';

abstract class LoanReportRepository {
  Future<LoanReportSummaryEntity> getLoanReports(String status);
}