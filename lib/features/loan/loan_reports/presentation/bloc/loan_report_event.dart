abstract class LoanReportEvent {}

class FetchLoanReportsEvent extends LoanReportEvent {
  final String status;
  FetchLoanReportsEvent({this.status = 'All'});
}