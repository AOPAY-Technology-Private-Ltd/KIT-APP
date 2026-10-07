import '../../domain/entities/loan_portfolio_entity.dart';
import '../../domain/repositories/loan_repository.dart';
import '../datasources/loan_history_remote_datasource.dart';


class LoanHistoryRepositoryImpl implements LoanHistoryRepository {
  final LoanHistoryRemoteDatasource remoteDatasource;

  LoanHistoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<LoanPortfolioEntity> getLoanPortfolioData() async {
    final model = await remoteDatasource.fetchLoanPortfolio();
    return model;
  }
}