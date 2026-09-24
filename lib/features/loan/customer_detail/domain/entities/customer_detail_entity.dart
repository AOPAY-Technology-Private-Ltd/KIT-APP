class CustomerDetailEntity {
  final String customerName;
  final String customerId;
  final String avatarUrl;
  final String status;
  final String loanNumber;
  final String nextEmiDate;
  final String loanType;
  final String loanCategory;
  final double emiAmount;
  final double loanAmount;
  final double downPayment;
  final String startDate;
  final String endDate;
  final int totalEmiCount;
  final int paidEmiCount;

  const CustomerDetailEntity({
    required this.customerName,
    required this.customerId,
    required this.avatarUrl,
    required this.status,
    required this.loanNumber,
    required this.nextEmiDate,
    required this.loanType,
    required this.loanCategory,
    required this.emiAmount,
    required this.loanAmount,
    required this.downPayment,
    required this.startDate,
    required this.endDate,
    required this.totalEmiCount,
    required this.paidEmiCount,
  });
}