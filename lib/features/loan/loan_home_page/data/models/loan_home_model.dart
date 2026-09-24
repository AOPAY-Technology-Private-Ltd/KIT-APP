import '../../domain/entities/loan_home_entity.dart';

class LoanCustomerModel extends LoanCustomerEntity {
  const LoanCustomerModel({
    required super.name,
    required super.details,
    required super.time,
    required super.initials,
  });

  factory LoanCustomerModel.fromJson(Map<String, dynamic> json) {
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

    return LoanCustomerModel(
      name: name,
      details: details,
      time: timeAgo,
      initials: initials,
    );
  }
}

class LoanHomeModel extends LoanHomeEntity {
  const LoanHomeModel({
    required super.retailerName,
    required super.retailerCode,
    required super.walletBalance,
    required super.totalLoan,
    required super.closedLoan,
    required super.settledLoan,
    required super.recentCustomers,
  });

  factory LoanHomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    var customersFromJson = data['recentCustomers'];
    List<dynamic> rawList = [];
    if (customersFromJson is List) {
      rawList = customersFromJson;
    }

    List<LoanCustomerModel> customerList = rawList
        .map((i) => LoanCustomerModel.fromJson(i as Map<String, dynamic>))
        .toList();

    return LoanHomeModel(
      retailerName: "Gupta’s Mobiles",
      retailerCode: "",
      walletBalance: data['walletBalance']?.toString() ?? "2,56,850.00",
      totalLoan: data['totalLoan'] ?? 20,
      closedLoan: data['closedLoan'] ?? 20,
      settledLoan: data['settledLoan'] ?? 20,
      recentCustomers: customerList,
    );
  }
}