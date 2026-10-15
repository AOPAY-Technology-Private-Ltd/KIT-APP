import '../../domain/entities/emi_customer_entity.dart';
import '../../domain/repositories/update_emi_repository.dart';
import '../datasources/update_emi_remote_datasource.dart';
import '../models/update_emi_request_model.dart';

class UpdateEmiRepositoryImpl implements UpdateEmiRepository {
  final UpdateEmiRemoteDataSource remoteDataSource;

  UpdateEmiRepositoryImpl(this.remoteDataSource);

  @override
  Future<EmiPaymentDetailModel> fetchEmiDetails() async {
    return await remoteDataSource.fetchEmiPaymentDetails();
  }

  @override
  Future<bool> updateEmi(EmiUpdateEntity emiEntity) async {
    final Map<String, dynamic> payload = {
      'loan_id': emiEntity.loanId,
      'number_of_emi': emiEntity.numberOfEmi,
      'payment_mode': emiEntity.paymentMode,
      'emi_amount': emiEntity.emiAmount,
      'late_fees': emiEntity.lateFees,
      'bounce_charges': emiEntity.bounceCharges,
      'payment_date': emiEntity.paymentDate,
      'status': emiEntity.status,
      'transaction_id': emiEntity.transactionId,
    };
    return await remoteDataSource.submitEmiUpdate(payload);
  }

  @override
  Future<bool> submitUpdate(Map<String, dynamic> payload) async {
    return await remoteDataSource.submitEmiUpdate(payload);
  }
}