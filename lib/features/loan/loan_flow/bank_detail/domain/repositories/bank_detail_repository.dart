import '../entities/bank_detail_entity.dart';

abstract class BankDetailRepository {
  Future<void> submitBankDetails(BankDetailEntity entity);
}