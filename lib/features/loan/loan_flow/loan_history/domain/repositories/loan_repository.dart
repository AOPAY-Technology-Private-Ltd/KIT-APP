import '../entities/loan_portfolio_entity.dart';

abstract class LoanHistoryRepository {
  Future<LoanPortfolioEntity> getLoanPortfolioData();
}