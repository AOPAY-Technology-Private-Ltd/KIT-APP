class LoanItemEntity {
  final String name;
  final String status; // 'Active', 'Closed', 'Disbursed'
  final String disbursedAmount;
  final String tenure;
  final String disbursalDate;

  LoanItemEntity({
    required this.name,
    required this.status,
    required this.disbursedAmount,
    required this.tenure,
    required this.disbursalDate,
  });
}