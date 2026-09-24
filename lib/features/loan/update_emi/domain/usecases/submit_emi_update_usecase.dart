import '../entities/emi_customer_entity.dart';
import '../repositories/update_emi_repository.dart';

class UpdateEmiUseCase {
  final UpdateEmiRepository repository;

  UpdateEmiUseCase(this.repository);

  Future<bool> call(EmiUpdateEntity emiEntity) async {
    return await repository.updateEmi(emiEntity);
  }
}