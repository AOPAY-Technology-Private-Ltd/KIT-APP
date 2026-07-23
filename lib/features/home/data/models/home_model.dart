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
    required super.recentCustomers,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var customersFromJson = json['recentCustomers'] as List? ?? [];
    List<CustomerModel> customerList =
    customersFromJson.map((i) => CustomerModel.fromJson(i)).toList();

    return HomeModel(
      retailerName: json['retailerName'] ?? '',
      retailerCode: json['retailerCode'] ?? '',
      availableKits: json['availableKits'] ?? 0,
      totalKits: json['totalKits'] ?? 0,
      totalInstalled: json['totalInstalled'] ?? 0,
      locked: json['locked'] ?? 0,
      todayInstalled: json['todayInstalled'] ?? 0,
      overdue: json['overdue'] ?? 0,
      recentCustomers: customerList,
    );
  }
}