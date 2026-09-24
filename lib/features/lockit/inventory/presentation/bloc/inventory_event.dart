abstract class InventoryEvent {}

class LoadInventoryEvent extends InventoryEvent {}

class FilterInventoryEvent extends InventoryEvent {
  final String status;
  FilterInventoryEvent(this.status);
}

class SearchInventoryEvent extends InventoryEvent {
  final String query;
  SearchInventoryEvent(this.query);
}