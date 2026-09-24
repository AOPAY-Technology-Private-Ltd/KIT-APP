import '../entities/loan_home_entity.dart';
import '../repositories/loan_home_repository.dart';

class GetLoanHomeDataUseCase {
  final LoanHomeRepository repository;

  GetLoanHomeDataUseCase(this.repository);

  Future<LoanHomeEntity> call() async {
    return await repository.getHomeData();
  }
}