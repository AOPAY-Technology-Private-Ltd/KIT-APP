import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../domain/usecaes/get_inventory_usecase.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventoryUseCase getInventoryUseCase;

  String _currentSearchQuery = '';

  InventoryBloc(this.getInventoryUseCase) : super(const InventoryInitial()) {
    on<LoadInventoryEvent>(_onLoadInventory);
    on<FilterInventoryEvent>(_onFilterInventory);
    on<SearchInventoryEvent>(_onSearchInventory);

    add(LoadInventoryEvent());
  }

  Future<void> _onLoadInventory(
      LoadInventoryEvent event,
      Emitter<InventoryState> emit,
      ) async {
    print('--- BLOC: LoadInventoryEvent started ---');
    emit(const InventoryLoading());
    try {
      _currentSearchQuery = '';
      print('--- BLOC: Fetching inventory from usecase ---');
      final items = await getInventoryUseCase();
      print('--- BLOC: Inventory fetched successfully. Total items: ${items.length} ---');

      final counts = {
        'total': items.length,
        'available': items.where((i) => i.status == 'available').length,
        'used': items.where((i) => i.status == 'used').length,
      };

      print('--- BLOC: Emitting InventoryLoaded state ---');
      emit(InventoryLoaded(
        allItems: items,
        filteredItems: items,
        currentFilter: 'all',
        counts: counts,
      ));
    } catch (e) {
      print('--- BLOC ERROR: Caught exception in loadinventory: $e ---');
      emit(InventoryError(e.toString()));
    }
  }

  void _onFilterInventory(
      FilterInventoryEvent event,
      Emitter<InventoryState> emit,
      ) {
    final currentState = state;
    if (currentState is InventoryLoaded) {
      _applyFilterAndSearch(emit, currentState, status: event.status);
    }
  }

  void _onSearchInventory(
      SearchInventoryEvent event,
      Emitter<InventoryState> emit,
      ) {
    final currentState = state;
    if (currentState is InventoryLoaded) {
      _currentSearchQuery = event.query;
      _applyFilterAndSearch(emit, currentState, searchQuery: event.query);
    }
  }

  void _applyFilterAndSearch(
      Emitter<InventoryState> emit,
      InventoryLoaded currentState, {
        String? status,
        String? searchQuery,
      }) {
    final activeStatus = status ?? currentState.currentFilter;
    final query = (searchQuery ?? _currentSearchQuery).toLowerCase();

    List<InventoryItem> tempItems = currentState.allItems;

    if (activeStatus != 'all') {
      tempItems = tempItems.where((i) => i.status == activeStatus).toList();
    }

    if (query.isNotEmpty) {
      tempItems = tempItems.where((item) =>
      item.serialNumber.toLowerCase().contains(query) ||
          item.assignedUser.toLowerCase().contains(query)).toList();
    }

    emit(InventoryLoaded(
      allItems: currentState.allItems,
      filteredItems: tempItems,
      currentFilter: activeStatus,
      counts: currentState.counts,
    ));
  }
}