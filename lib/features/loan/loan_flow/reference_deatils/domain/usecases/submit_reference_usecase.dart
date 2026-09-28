import '../entities/reference_entity.dart';
import '../repositories/reference_repository.dart';

class SubmitReferenceUseCase {
  final ReferenceRepository repository;

  SubmitReferenceUseCase(this.repository);

  Future<void> call(ReferenceEntity referenceEntity) async {
    return await repository.submitReferenceDetail(referenceEntity);
  }
}