import '../models/bank_detail_model.dart';

abstract class BankDetailRemoteDataSource {
  Future<void> submitBankDetails(BankDetailModel model);
}

class BankDetailRemoteDataSourceImpl implements BankDetailRemoteDataSource {


  @override
  Future<void> submitBankDetails(BankDetailModel model) async {
    try {

      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}