abstract class EnachReviewRepository {
  Future<void> updateEnachStatus({
    required String customerId,
    required String status,
    String? remarks,
  });
}