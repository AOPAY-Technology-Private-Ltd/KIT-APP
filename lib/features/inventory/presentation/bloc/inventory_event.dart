abstract class InventoryEvent {
  const InventoryEvent();
}

class LoadInventoryEvent extends InventoryEvent {
  const LoadInventoryEvent();
}

class FilterInventoryEvent extends InventoryEvent {
  final String status;
  const FilterInventoryEvent(this.status);
}