import '../entities/emandate_entity.dart';
import '../repositories/emandate_repository.dart';

class SubmitEmandateUseCase {
  final EmandateRepository repository;

  SubmitEmandateUseCase(this.repository);

  Future<void> call(EmandateEntity entity) async {
    return await repository.submitEmandate(entity);
  }
}