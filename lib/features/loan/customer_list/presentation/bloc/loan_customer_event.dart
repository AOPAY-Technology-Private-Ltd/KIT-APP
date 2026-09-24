abstract class LoanCustomerEvent {}

class FetchLoanCustomersEvent extends LoanCustomerEvent {
  final String status;
  FetchLoanCustomersEvent({this.status = 'Active'});
}