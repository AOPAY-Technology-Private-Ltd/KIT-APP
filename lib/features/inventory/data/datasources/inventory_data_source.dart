import '../models/inventory_model.dart';

abstract class InventoryDataSource {
  Future<List<InventoryModel>> fetchInventoryData();
}
class InventoryMockDataSource implements InventoryDataSource {
  @override
  Future<List<InventoryModel>> fetchInventoryData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return [
      InventoryModel(
        id: '1',
        serialNumber: 'LK-7F2K-9XQ4',
        assignedUser: "Ronnit Mitra's Phone",
        status: 'used',
        installedDate: DateTime(2026, 6, 24),
        groupMonth: 'This Month',
      ),
      InventoryModel(
        id: '2',
        serialNumber: 'LK-7F2K-9XQ4',
        assignedUser: "Ronnit Mitra's Phone",
        status: 'used',
        installedDate: DateTime(2026, 6, 24),
        groupMonth: 'This Month',
      ),
      InventoryModel(
        id: '3',
        serialNumber: 'LK-7F2K-9XQ4',
        assignedUser: "Ronnit Mitra's Phone",
        status: 'available',
        installedDate: DateTime(2026, 6, 24),
        groupMonth: 'This Month',
      ),
      InventoryModel(
        id: '4',
        serialNumber: 'LK-7F2K-9XQ4',
        assignedUser: "Ronnit Mitra's Phone",
        status: 'closed',
        installedDate: DateTime(2026, 6, 24),
        groupMonth: 'June, 2026',
      ),
      InventoryModel(
        id: '5',
        serialNumber: 'LK-7F2K-9XQ4',
        assignedUser: "Ronnit Mitra's Phone",
        status: 'available',
        installedDate: DateTime(2026, 6, 24),
        groupMonth: 'June, 2026',
      ),
    ];
  }
}