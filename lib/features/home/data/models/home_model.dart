import '../../domain/entities/home_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.name,
    required super.details,
    required super.time,
    required super.initials,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final name = json['customerName'] ?? json['name'] ?? '';

    final mobile = json['mobileNo'] ?? '';
    final details = mobile.isNotEmpty ? "Mobile: $mobile" : (json['details'] ?? '');

    final rawDate = json['createdDate'] ?? json['time'] ?? '';
    String timeAgo = "Just now";
    if (rawDate.toString().isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(rawDate);
        final difference = DateTime.now().difference(parsedDate);
        if (difference.inMinutes < 60) {
          timeAgo = "${difference.inMinutes}min ago";
        } else if (difference.inHours < 24) {
          timeAgo = "${difference.inHours}h ago";
        } else {
          timeAgo = "${difference.inDays}d ago";
        }
      } catch (_) {
        timeAgo = "Recently";
      }
    }

    String initials = "C";
    if (name.isNotEmpty) {
      List<String> nameParts = name.trim().split(' ');
      if (nameParts.length > 1) {
        initials = "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
      } else if (nameParts[0].isNotEmpty) {
        initials = nameParts[0][0].toUpperCase();
      }
    }

    return CustomerModel(
      name: name,
      details: details,
      time: timeAgo,
      initials: initials,
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

    var customersFromJson = data['recentCustomers'];

    List<dynamic> rawList = [];
    if (customersFromJson is List) {
      rawList = customersFromJson;
    }

    List<CustomerModel> customerList = rawList
        .map((i) => CustomerModel.fromJson(i as Map<String, dynamic>))
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