class InventoryItem {
  final String id;
  final String serialNumber;
  final String assignedUser;
  final String status;
  final DateTime installedDate;
  final String groupMonth;

  const InventoryItem({
    required this.id,
    required this.serialNumber,
    required this.assignedUser,
    required this.status,
    required this.installedDate,
    required this.groupMonth,
  });
}