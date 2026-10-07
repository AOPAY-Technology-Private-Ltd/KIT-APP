import 'package:http/http.dart' as http;
import '../models/loan_portfolio_model.dart';

abstract class LoanHistoryRemoteDatasource {
  Future<LoanPortfolioModel> fetchLoanPortfolio();
}

class LoanHistoryRemoteDatasourceImpl implements LoanHistoryRemoteDatasource {
  final http.Client? client;

  LoanHistoryRemoteDatasourceImpl({this.client});

  @override
  Future<LoanPortfolioModel> fetchLoanPortfolio() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final Map<String, dynamic> mockJsonResponse = {
      "total_disbursed": 450000.0,
      "active_loans_count": 12,
      "total_entries": 25,
      "currency_symbol": "₹"
    };

    return LoanPortfolioModel.fromJson(mockJsonResponse);
  }
}