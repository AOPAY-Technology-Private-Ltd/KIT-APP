import '../../domain/entities/loan_portfolio_entity.dart';

class LoanPortfolioModel extends LoanPortfolioEntity {
  const LoanPortfolioModel({
    required super.totalDisbursed,
    required super.activeLoansCount,
    required super.totalEntries,
    required super.currencySymbol,
    required super.loanList,
  });

  factory LoanPortfolioModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    final List<dynamic> historyJson = data['loanHistory'] ?? [];
    final List<LoanItemEntity> parsedLoans = historyJson.map((item) {
      return LoanItemEntity(
        name: item['customerName'] ?? 'Unknown',
        status: item['loanStatus'] ?? 'Disbursed',
        disbursedAmount: '₹${item['disbursedAmount']?.toString() ?? '0'}',
        tenure: '${item['tenure']?.toString() ?? '0'} Months',
        disbursalDate: _formatDate(item['disbursalDate']),
      );
    }).toList();

    return LoanPortfolioModel(
      totalDisbursed: (data['totalDisbursedPortfolio'] as num?)?.toDouble() ?? 0.0,
      activeLoansCount: data['activeLoans'] ?? 0,
      totalEntries: data['totalEntries'] ?? 0,
      currencySymbol: '₹',
      loanList: parsedLoans,
    );
  }

  static String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(rawDate);
      final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (e) {
      return rawDate;
    }
  }
}