import '../repositories/bank_detail_repository.dart';

class GetBankListUseCase {
  final BankDetailRepository repository;

  GetBankListUseCase(this.repository);

  Future<List<String>> call(String registrationId) async {
    return await repository.getBankList(registrationId);
  }
}