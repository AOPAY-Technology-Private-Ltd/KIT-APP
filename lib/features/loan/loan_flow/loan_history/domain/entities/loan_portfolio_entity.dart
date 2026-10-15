class LoanItemEntity {
  final String name;
  final String status;
  final String disbursedAmount;
  final String tenure;
  final String disbursalDate;

  const LoanItemEntity({
    required this.name,
    required this.status,
    required this.disbursedAmount,
    required this.tenure,
    required this.disbursalDate,
  });
}

class LoanPortfolioEntity {
  final double totalDisbursed;
  final int activeLoansCount;
  final int totalEntries;
  final String currencySymbol;
  final List<LoanItemEntity> loanList;

  const LoanPortfolioEntity({
    required this.totalDisbursed,
    required this.activeLoansCount,
    required this.totalEntries,
    required this.currencySymbol,
    required this.loanList,
  });
}