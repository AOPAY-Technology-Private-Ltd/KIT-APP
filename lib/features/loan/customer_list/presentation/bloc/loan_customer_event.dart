abstract class LoanCustomerEvent {}

class FetchLoanCustomersEvent extends LoanCustomerEvent {
  final String status;
  final String search;

  FetchLoanCustomersEvent({
    required this.status,
    this.search = '',
  });
}