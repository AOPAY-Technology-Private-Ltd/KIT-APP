import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inventory_entity.dart';
import '../../domain/usecaes/get_inventory_usecase.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventoryUseCase getInventoryUseCase;

  InventoryBloc(this.getInventoryUseCase) : super(const InventoryInitial()) {
    on<LoadInventoryEvent>(_onLoadInventory);
    on<FilterInventoryEvent>(_onFilterInventory);
  }

  Future<void> _onLoadInventory(
      LoadInventoryEvent event,
      Emitter<InventoryState> emit,
      ) async {
    emit(const InventoryLoading());
    try {
      final items = await getInventoryUseCase();

      final counts = {
        'total': items.length,
        'available': items.where((i) => i.status == 'available').length,
        'used': items.where((i) => i.status == 'used').length,
        'closed': items.where((i) => i.status == 'closed').length,
      };

      emit(InventoryLoaded(
        allItems: items,
        filteredItems: items,
        currentFilter: 'all',
        counts: counts,
      ));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }


  void _onFilterInventory(
      FilterInventoryEvent event,
      Emitter<InventoryState> emit,
      ) {
    final currentState = state;
    if (currentState is InventoryLoaded) {
      List<InventoryItem> filtered;

      if (event.status == 'all') {
        filtered = currentState.allItems;
      } else {
        filtered = currentState.allItems
            .where((i) => i.status == event.status)
            .toList();
      }

      emit(InventoryLoaded(
        allItems: currentState.allItems,
        filteredItems: filtered,
        currentFilter: event.status,
        counts: currentState.counts,
      ));
    }
  }}