import '../../domain/entities/loan_home_entity.dart';

class LoanCustomerModel extends LoanCustomerEntity {
  const LoanCustomerModel({
    required super.name,
    required super.details,
    required super.time,
    required super.initials,
  });

  factory LoanCustomerModel.fromJson(Map<String, dynamic> json) {
    final name = (json['customerName'] ?? json['name'] ?? 'Unknown').toString().trim();

    final loanCode = json['loanCode'] ?? '';
    final amount = json['loanAmount']?.toString() ?? '0';

    // 🛠️ Fixed syntax error and formatted details cleanly
    final details = loanCode.isNotEmpty
        ? "Loan ID: $loanCode • ₹$amount"
        : "Amount: ₹$amount";

    final rawDate = json['activityDate'] ?? json['createdDate'] ?? json['time'] ?? '';
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
    final nameParts = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (nameParts.isNotEmpty) {
      initials = nameParts.first[0].toUpperCase();
      if (nameParts.length > 1) {
        initials += nameParts[1][0].toUpperCase();
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
    final data = json['data'];
    final Map<String, dynamic> dataMap = data is Map<String, dynamic> ? data : {};

    final rawCustomers = dataMap['recentCustomers'];
    final List<LoanCustomerModel> customerList = [];

    if (rawCustomers is List) {
      for (final item in rawCustomers) {
        if (item is Map<String, dynamic>) {
          customerList.add(LoanCustomerModel.fromJson(item));
        }
      }
    }

    return LoanHomeModel(
      retailerName: "",
      retailerCode: "",
      walletBalance: "2,56,850.00",
      totalLoan: dataMap['totalLoan'] ?? 0,
      closedLoan: dataMap['closedLoan'] ?? 0,
      settledLoan: dataMap['settledLoan'] ?? 0,
      recentCustomers: customerList,
    );
  }
}