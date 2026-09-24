import '../entities/inventory_entity.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getInventoryItems();
}