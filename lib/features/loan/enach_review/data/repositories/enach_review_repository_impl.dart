
import '../../domain/repositories/enach_review_repository.dart';
import '../datasources/enach_review_remote_datasource.dart';

class EnachReviewRepositoryImpl implements EnachReviewRepository {
  final EnachReviewRemoteDataSource remoteDataSource;

  EnachReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> updateEnachStatus({
    required String customerId,
    required String status,
    String? remarks,
  }) async {
    return await remoteDataSource.updateStatus(
      customerId: customerId,
      status: status,
      remarks: remarks,
    );
  }
}