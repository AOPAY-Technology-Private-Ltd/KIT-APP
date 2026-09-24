import '../../domain/entities/inventory_entity.dart';

abstract class InventoryState {
  const InventoryState();
}

class InventoryInitial extends InventoryState {
  const InventoryInitial();
}

class InventoryLoading extends InventoryState {
  const InventoryLoading();
}

class InventoryLoaded extends InventoryState {
  final List<InventoryItem> allItems;
  final List<InventoryItem> filteredItems;
  final String currentFilter;
  final Map<String, int> counts;

  const InventoryLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.currentFilter,
    required this.counts,
  });
}

class InventoryError extends InventoryState {
  final String message;
  const InventoryError(this.message);
}