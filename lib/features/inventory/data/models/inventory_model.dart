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
    // 👉 Aapke naye Swagger JSON response ke fields ke mutabiq mapping
    final purchaseCodeStr = json['purchaseCode']?.toString() ?? json['transactionNo']?.toString() ?? '';
    final planNameStr = json['planName']?.toString() ?? 'Unknown Plan';

    final purchaseDateStr = json['purchaseDate']?.toString();
    DateTime parsedDate = DateTime.now();
    if (purchaseDateStr != null && purchaseDateStr.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(purchaseDateStr);
      } catch (_) {}
    }

    String groupMonthStr = 'This Month';
    try {
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      groupMonthStr = '${months[parsedDate.month - 1]}, ${parsedDate.year}';
    } catch (_) {}

    final paymentStatusStr = (json['paymentStatus'] ?? 'SUCCESS').toString().toLowerCase();

    return InventoryModel(
      id: purchaseCodeStr,
      serialNumber: purchaseCodeStr, // List me serial number ki jagah purchase code dikhega
      assignedUser: planNameStr,      // List me customer name ki jagah plan name dikhega
      status: paymentStatusStr,       // Status me payment status (success) aayega
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