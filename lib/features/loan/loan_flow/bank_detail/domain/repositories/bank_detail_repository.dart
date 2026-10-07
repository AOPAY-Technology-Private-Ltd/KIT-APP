import '../entities/bank_detail_entity.dart';

abstract class BankDetailRepository {
  Future<void> submitBankDetails(BankDetailEntity entity);
  Future<List<String>> getBankList(String registrationId);
  Future<Map<String, String>> setupAutoUpiSubscription(String registrationId);
  Future<bool> checkOrderStatus({required String registrationId, required String merchantOrderId});

  Future<Map<String, String>> postTransactionWithResponse({
    required String registrationId,
    required String loanCode,
    required String emiNumbers,
  });

  Future<void> manageCustomerStepWiseForStep4({required String registrationId});
}