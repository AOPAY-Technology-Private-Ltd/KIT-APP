import '../../domain/entities/loan_home_entity.dart';
import '../../domain/repositories/loan_home_repository.dart';
import '../datasources/loan_home_remote_datasource.dart';

class LoanHomeRepositoryImpl implements LoanHomeRepository {
  final LoanHomeRemoteDataSource remoteDataSource;

  LoanHomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoanHomeEntity> getHomeData() async {
    final homeModel = await remoteDataSource.fetchHomeData();

    return LoanHomeEntity(
      retailerName: homeModel.retailerName,
      retailerCode: homeModel.retailerCode,
      walletBalance: homeModel.walletBalance,
      totalLoan: homeModel.totalLoan,
      closedLoan: homeModel.closedLoan,
      settledLoan: homeModel.settledLoan,
      recentCustomers: homeModel.recentCustomers,
    );
  }
}