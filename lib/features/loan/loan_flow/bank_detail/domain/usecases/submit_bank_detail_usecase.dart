import '../entities/bank_detail_entity.dart';
import '../repositories/bank_detail_repository.dart';

class SubmitBankDetailUseCase {
  final BankDetailRepository repository;

  SubmitBankDetailUseCase(this.repository);

  Future<void> call(BankDetailEntity entity) async {
    return await repository.submitBankDetails(entity);
  }
}