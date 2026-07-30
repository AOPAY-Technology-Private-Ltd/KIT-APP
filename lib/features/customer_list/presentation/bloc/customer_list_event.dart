import '../widgets/customer_list_tabs.dart';

abstract class CustomerListEvent {}

class FetchCustomerListEvent extends CustomerListEvent {}

class FilterCustomerTabEvent extends CustomerListEvent {
  final CustomerTabType tabType;

  FilterCustomerTabEvent(this.tabType);
}