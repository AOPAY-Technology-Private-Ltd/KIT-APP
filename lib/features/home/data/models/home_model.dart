import '../../domain/entities/home_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.name,
    required super.details,
    required super.time,
    required super.initials,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      time: json['time'] ?? '',
      initials: json['initials'] ?? '',
    );
  }
}

class HomeModel extends HomeEntity {
  const HomeModel({
    required super.retailerName,
    required super.retailerCode,
    required super.availableKits,
    required super.totalKits,
    required super.totalInstalled,
    required super.locked,
    required super.todayInstalled,
    required super.overdue,
    required super.totalPurchasedKits,
    required super.usedKits,
    required super.lockedDevices,
    required super.unlockedDevices,
    required super.recentCustomers,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    var customersFromJson = data['recentCustomers'] ?? [
      {"name": "Rahul Verma", "details": "Redmi Note 13, EMI Paid: 1/6", "time": "2min ago", "initials": "RV"},
      {"name": "Priya Sharma", "details": "Redmi Note 13, EMI Paid: 1/6", "time": "2min ago", "initials": "PS"},
    ];

    List<CustomerModel> customerList = (customersFromJson as List)
        .map((i) => CustomerModel.fromJson(i))
        .toList();

    return HomeModel(
      retailerName: "Gupta’s Mobiles",
      retailerCode: "",
      availableKits: data['availableKits'] ?? 0,
      totalKits: data['totalKits'] ?? 0,
      totalInstalled: data['usedKits'] ?? 0,
      locked: data['lockedDevices'] ?? 0,
      todayInstalled: data['unlockedDevices'] ?? 0,
      overdue: 0,
      totalPurchasedKits: data['totalPurchasedKits'] ?? 0,
      usedKits: data['usedKits'] ?? 0,
      lockedDevices: data['lockedDevices'] ?? 0,
      unlockedDevices: data['unlockedDevices'] ?? 0,
      recentCustomers: customerList,
    );
  }
}