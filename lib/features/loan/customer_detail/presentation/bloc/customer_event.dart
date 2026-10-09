abstract class CustomerEvent {}

class FetchCustomerDetailEvent extends CustomerEvent {
  final String searchText;

  FetchCustomerDetailEvent({required this.searchText});
}