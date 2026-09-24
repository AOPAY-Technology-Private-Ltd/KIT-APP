import '../../domain/entities/inventory_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryDataSource dataSource;

  InventoryRepositoryImpl(this.dataSource);

  @override
  Future<List<InventoryItem>> getInventoryItems() async {
    final inventoryModels = await dataSource.fetchInventoryData();
    return inventoryModels;
  }
}