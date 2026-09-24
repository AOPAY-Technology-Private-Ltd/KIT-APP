import '../entities/inventory_entity.dart';
import '../repositories/inventory_repository.dart';

class GetInventoryUseCase {
  final InventoryRepository repository;

  GetInventoryUseCase(this.repository);

  Future<List<InventoryItem>> call() async {
    return await repository.getInventoryItems();
  }
}