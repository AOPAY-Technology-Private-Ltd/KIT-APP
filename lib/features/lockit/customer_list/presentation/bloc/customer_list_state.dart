import '../../domain/entities/customer_item_entity.dart';
import '../widgets/customer_list_tabs.dart';

abstract class CustomerListState {}

class CustomerListInitial extends CustomerListState {}

class CustomerListLoading extends CustomerListState {}

class CustomerListLoaded extends CustomerListState {
  final List<CustomerItemEntity> displayedCustomers;
  final CustomerTabType selectedTab;
  final String searchQuery;

  CustomerListLoaded({
    required this.displayedCustomers,
    required this.selectedTab,
    required this.searchQuery,
  });
}

class CustomerListError extends CustomerListState {
  final String message;

  CustomerListError(this.message);
}