import '../repositories/enach_review_repository.dart';

class UpdateEnachStatusUsecase {
  final EnachReviewRepository repository;

  UpdateEnachStatusUsecase(this.repository);

  Future<void> call({
    required String customerId,
    required String status,
    String? remarks,
  }) async {
    return await repository.updateEnachStatus(
      customerId: customerId,
      status: status,
      remarks: remarks,
    );
  }
}