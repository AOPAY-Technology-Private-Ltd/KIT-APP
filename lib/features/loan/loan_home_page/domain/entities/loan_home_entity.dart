class LoanCustomerEntity {
  final String name;
  final String details;
  final String time;
  final String initials;

  const LoanCustomerEntity({
    required this.name,
    required this.details,
    required this.time,
    required this.initials,
  });
}

class LoanHomeEntity {
  final String retailerName;
  final String retailerCode;
  final String walletBalance;
  final int totalLoan;
  final int closedLoan;
  final int settledLoan;
  final List<LoanCustomerEntity> recentCustomers;

  const LoanHomeEntity({
    required this.retailerName,
    required this.retailerCode,
    required this.walletBalance,
    required this.totalLoan,
    required this.closedLoan,
    required this.settledLoan,
    required this.recentCustomers,
  });
}