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
    return InventoryModel(
      id: json['id'].toString(),
      serialNumber: json['serial_number'] ?? '',
      assignedUser: json['assigned_user'] ?? '',
      status: json['status'] ?? 'available',
      installedDate: DateTime.parse(json['installed_date']),
      groupMonth: json['group_month'] ?? 'This Month',
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