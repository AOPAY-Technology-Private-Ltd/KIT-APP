class LoanPortfolioEntity {
  final double totalDisbursed;
  final int activeLoansCount;
  final int totalEntries;
  final String currencySymbol;

  const LoanPortfolioEntity({
    required this.totalDisbursed,
    required this.activeLoansCount,
    required this.totalEntries,
    required this.currencySymbol,
  });
}