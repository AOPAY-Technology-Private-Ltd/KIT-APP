import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer_item_entity.dart';
import '../../domain/usecases/get_customer_list_usecase.dart';
import '../widgets/customer_list_tabs.dart';
import 'customer_list_event.dart';
import 'customer_list_state.dart';

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  final GetCustomerListUseCase getCustomerListUseCase;

  List<CustomerItemEntity> _allCustomers = [];

  CustomerListBloc({required this.getCustomerListUseCase}) : super(CustomerListInitial()) {
    on<FetchCustomerListEvent>(_onFetchCustomerList);
    on<FilterCustomerTabEvent>(_onFilterCustomerTab);
  }

  Future<void> _onFetchCustomerList(
      FetchCustomerListEvent event,
      Emitter<CustomerListState> emit,
      ) async {
    emit(CustomerListLoading());
    try {
      final customers = await getCustomerListUseCase();

      _allCustomers = customers;
      emit(CustomerListLoaded(
        displayedCustomers: _allCustomers,
        selectedTab: CustomerTabType.all,
      ));
    } catch (e) {
      emit(CustomerListError(e.toString()));
    }
  }

  void _onFilterCustomerTab(
      FilterCustomerTabEvent event,
      Emitter<CustomerListState> emit,
      ) {
    List<CustomerItemEntity> filteredList = [];

    switch (event.tabType) {
      case CustomerTabType.all:
        filteredList = _allCustomers;
        break;
      case CustomerTabType.overdue:
        filteredList = _allCustomers.where((c) => c.scheduleLockStatus.toUpperCase() == 'ON').toList();
        break;
      case CustomerTabType.locked:
      // Locked tab ke liye filtering logic (e.g., c.isLocked == true)
        filteredList = _allCustomers.where((c) => c.isLocked).toList();
        break;
      case CustomerTabType.upcoming:
      // Upcoming tab ke liye apna logic lagayein
        filteredList = _allCustomers.where((c) => !c.isLocked).toList();
        break;
    }

    emit(CustomerListLoaded(
      displayedCustomers: filteredList,
      selectedTab: event.tabType,
    ));
  }
}