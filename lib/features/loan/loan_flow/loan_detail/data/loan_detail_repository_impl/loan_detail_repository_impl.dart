import '../../domain/entities/loan_detail_entity.dart';
import '../../domain/repositories/loan_detail_repository.dart';
import '../datasources/loan_detail_remote_datasource.dart';
import '../models/loan_detail_model.dart';

class LoanDetailRepositoryImpl implements LoanDetailRepository {
  final LoanDetailRemoteDataSource remoteDataSource;

  LoanDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitLoanDetail(LoanDetailEntity loanDetail) async {
    final model = LoanDetailModel(
      productCategory: loanDetail.productCategory,
      brand: loanDetail.brand,
      model: loanDetail.model,
      loanAmount: loanDetail.loanAmount,
      downPayment: loanDetail.downPayment,
      processFees: loanDetail.processFees,
      forecloseCharges: loanDetail.forecloseCharges,
      interestType: loanDetail.interestType,
      tenure: loanDetail.tenure,
      interestRate: loanDetail.interestRate,
    );
    await remoteDataSource.uploadLoanDetail(model);
  }
}