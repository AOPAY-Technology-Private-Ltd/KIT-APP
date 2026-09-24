import '../../domain/entities/loan_report_entity.dart';

abstract class LoanReportState {}

class LoanReportInitialState extends LoanReportState {}

class LoanReportLoadingState extends LoanReportState {}

class LoanReportLoadedState extends LoanReportState {
  final LoanReportSummaryEntity summary;
  final String selectedFilter;

  LoanReportLoadedState({required this.summary, required this.selectedFilter});
}

class LoanReportErrorState extends LoanReportState {
  final String message;
  LoanReportErrorState(this.message);
}