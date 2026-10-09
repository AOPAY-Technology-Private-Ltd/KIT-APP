abstract class EnachReviewRemoteDataSource {
  Future<void> updateStatus({required String customerId, required String status, String? remarks});
}

class EnachReviewRemoteDataSourceImpl implements EnachReviewRemoteDataSource {


  @override
  Future<void> updateStatus({required String customerId, required String status, String? remarks}) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}