import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer_item_entity.dart';
import '../../domain/usecases/get_customer_list_usecase.dart';
import '../widgets/customer_list_tabs.dart';
import 'customer_list_event.dart';
import 'customer_list_state.dart';

class CustomerListBloc extends Bloc<CustomerListEvent, CustomerListState> {
  final GetCustomerListUseCase getCustomerListUseCase;

  List<CustomerItemEntity> _allCustomers = [];
  CustomerTabType _currentTab = CustomerTabType.all;
  String _searchQuery = '';

  CustomerListBloc({required this.getCustomerListUseCase}) : super(CustomerListInitial()) {
    on<FetchCustomerListEvent>(_onFetchCustomerList);
    on<FilterCustomerTabEvent>(_onFilterCustomerTab);
    on<SearchCustomerEvent>(_onSearchCustomer);
  }

  Future<void> _onFetchCustomerList(
      FetchCustomerListEvent event,
      Emitter<CustomerListState> emit,
      ) async {
    emit(CustomerListLoading());
    try {
      final customers = await getCustomerListUseCase();
      _allCustomers = customers;
      _currentTab = CustomerTabType.all;
      _searchQuery = '';

      emit(CustomerListLoaded(
        displayedCustomers: _allCustomers,
        selectedTab: _currentTab,
        searchQuery: _searchQuery,
      ));
    } catch (e) {
      emit(CustomerListError(e.toString()));
    }
  }

  void _onFilterCustomerTab(
      FilterCustomerTabEvent event,
      Emitter<CustomerListState> emit,
      ) {
    _currentTab = event.tabType;
    _emitFilteredList(emit);
  }

  void _onSearchCustomer(
      SearchCustomerEvent event,
      Emitter<CustomerListState> emit,
      ) {
    _searchQuery = event.query.toLowerCase();
    _emitFilteredList(emit);
  }

  void _emitFilteredList(Emitter<CustomerListState> emit) {
    List<CustomerItemEntity> list = _allCustomers;

    if (_currentTab == CustomerTabType.locked) {
      list = list.where((c) => c.isLocked).toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = list.where((c) {
        return c.name.toLowerCase().contains(_searchQuery) ||
            c.mobile.toLowerCase().contains(_searchQuery) ||
            c.email.toLowerCase().contains(_searchQuery) ||
            c.customerIdCode.toLowerCase().contains(_searchQuery) ||
            c.imei1.toLowerCase().contains(_searchQuery) ||
            c.imei2.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    emit(CustomerListLoaded(
      displayedCustomers: list,
      selectedTab: _currentTab,
      searchQuery: _searchQuery,
    ));
  }
}