import '../repositories/bank_detail_repository.dart';

class SetupAutoUpiUseCase {
  final BankDetailRepository repository;

  SetupAutoUpiUseCase(this.repository);

  Future<Map<String, String>> call(String registrationId) async {
    return await repository.setupAutoUpiSubscription(registrationId);
  }
}