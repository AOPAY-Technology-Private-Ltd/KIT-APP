import '../entities/loan_portfolio_entity.dart';
import '../repositories/loan_repository.dart';

class GetLoanPortfolioUsecase {
  final LoanHistoryRepository repository;

  GetLoanPortfolioUsecase(this.repository);

  Future<LoanPortfolioEntity> call() async {
    return await repository.getLoanPortfolioData();
  }
}