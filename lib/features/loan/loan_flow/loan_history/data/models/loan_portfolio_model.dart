import '../../domain/entities/loan_portfolio_entity.dart';

class LoanPortfolioModel extends LoanPortfolioEntity {
  const LoanPortfolioModel({
    required super.totalDisbursed,
    required super.activeLoansCount,
    required super.totalEntries,
    required super.currencySymbol,
  });

  factory LoanPortfolioModel.fromJson(Map<String, dynamic> json) {
    return LoanPortfolioModel(
      totalDisbursed: (json['total_disbursed'] as num?)?.toDouble() ?? 0.0,
      activeLoansCount: json['active_loans_count'] ?? 0,
      totalEntries: json['total_entries'] ?? 0,
      currencySymbol: json['currency_symbol'] ?? '₹',
    );
  }
}