import '../../domain/entities/loan_report_entity.dart';
import '../../domain/repositories/loan_report_repository.dart';
import '../datasources/loan_report_remote_data_source.dart';
import '../models/loan_report_model.dart';

class LoanReportRepositoryImpl implements LoanReportRepository {
  final LoanReportRemoteDataSource remoteDataSource;

  LoanReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoanReportSummaryEntity> getLoanReports(String status) async {
    final response = await remoteDataSource.fetchReports(status);

    int totalCount = response['totalCount'];
    double totalVolume = response['totalVolume'];
    List<LoanReportModel> models = response['loans'];

    return LoanReportSummaryEntity(
      totalDisbursedCount: totalCount,
      totalVolume: totalVolume,
      loans: models,
    );
  }
}