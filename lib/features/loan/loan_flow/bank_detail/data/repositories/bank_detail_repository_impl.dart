import '../../domain/entities/bank_detail_entity.dart';
import '../../domain/repositories/bank_detail_repository.dart';
import '../datasources/bank_detail_remote_data_source.dart';
import '../models/bank_detail_model.dart';

class BankDetailRepositoryImpl implements BankDetailRepository {
  final BankDetailRemoteDataSource remoteDataSource;

  BankDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitBankDetails(BankDetailEntity entity) async {
    final model = BankDetailModel.fromEntity(entity);
    await remoteDataSource.submitBankDetails(model);
  }

  @override
  Future<List<String>> getBankList(String registrationId) async {
    return await remoteDataSource.getBankList(registrationId);
  }

  @override
  Future<Map<String, String>> setupAutoUpiSubscription(String registrationId) async {
    return await remoteDataSource.setupAutoUpiSubscription(registrationId);
  }

  @override
  Future<bool> checkOrderStatus({required String registrationId, required String merchantOrderId}) async {
    return await remoteDataSource.checkOrderStatus(
      registrationId: registrationId,
      merchantOrderId: merchantOrderId,
    );
  }

  @override
  Future<Map<String, String>> postTransactionWithResponse({
    required String registrationId,
    required String loanCode,
    required String emiNumbers,
  }) async {
    return await remoteDataSource.postTransactionWithResponse(
      registrationId: registrationId,
      loanCode: loanCode,
      emiNumbers: emiNumbers,
    );
  }

  @override
  Future<void> manageCustomerStepWiseForStep4({required String registrationId}) async {
    await remoteDataSource.manageCustomerStepWiseForStep4(
      registrationId: registrationId,
    );
  }
}