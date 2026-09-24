import '../entities/loan_home_entity.dart';

abstract class LoanHomeRepository {
  Future<LoanHomeEntity> getHomeData();
}