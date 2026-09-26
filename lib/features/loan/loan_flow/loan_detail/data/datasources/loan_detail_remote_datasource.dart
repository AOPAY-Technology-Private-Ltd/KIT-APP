import '../models/loan_detail_model.dart';

abstract class LoanDetailRemoteDataSource {
  Future<void> uploadLoanDetail(LoanDetailModel model);
}

class LoanDetailRemoteDataSourceImpl implements LoanDetailRemoteDataSource {
  @override
  Future<void> uploadLoanDetail(LoanDetailModel model) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}