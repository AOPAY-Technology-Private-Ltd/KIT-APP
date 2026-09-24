import '../../domain/entities/inventory_entity.dart';

class InventoryModel extends InventoryItem {
  const InventoryModel({
    required super.id,
    required super.serialNumber,
    required super.assignedUser,
    required super.status,
    required super.installedDate,
    required super.groupMonth,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    final installedOnStr = json['installedOn'];
    DateTime parsedDate = DateTime.now();
    if (installedOnStr != null && installedOnStr.toString().isNotEmpty) {
      try {
        parsedDate = DateTime.parse(installedOnStr);
      } catch (_) {}
    }

    String groupMonthStr = 'This Month';
    try {
      const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      groupMonthStr = '${months[parsedDate.month - 1]}, ${parsedDate.year}';
    } catch (_) {}

    final rawStatus = (json['kitStatus'] ?? 'AVAILABLE').toString().toLowerCase();

    return InventoryModel(
      id: json['serialNo']?.toString() ?? '1',
      serialNumber: json['serialNumber'] ?? '',
      assignedUser: json['customerName'] ?? json['deviceName'] ?? '',
      status: rawStatus,
      installedDate: parsedDate,
      groupMonth: groupMonthStr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'assigned_user': assignedUser,
      'status': status,
      'installed_date': installedDate.toIso8601String(),
      'group_month': groupMonth,
    };
  }
}