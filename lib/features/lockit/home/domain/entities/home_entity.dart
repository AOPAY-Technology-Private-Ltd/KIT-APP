class CustomerEntity {
  final String name;
  final String details;
  final String time;
  final String initials;

  const CustomerEntity({
    required this.name,
    required this.details,
    required this.time,
    required this.initials,
  });
}

class HomeEntity {
  final String retailerName;
  final String retailerCode;
  final int availableKits;
  final int totalKits;
  final int totalInstalled;
  final int locked;
  final int todayInstalled;
  final int overdue;

  final int totalPurchasedKits;
  final int usedKits;
  final int lockedDevices;
  final int unlockedDevices;

  final List<CustomerEntity> recentCustomers;

  const HomeEntity({
    required this.retailerName,
    required this.retailerCode,
    required this.availableKits,
    required this.totalKits,
    required this.totalInstalled,
    required this.locked,
    required this.todayInstalled,
    required this.overdue,
    required this.totalPurchasedKits,
    required this.usedKits,
    required this.lockedDevices,
    required this.unlockedDevices,
    required this.recentCustomers,
  });
}