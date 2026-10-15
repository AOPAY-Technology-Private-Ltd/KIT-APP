import '../../data/models/update_emi_request_model.dart';
import '../entities/emi_customer_entity.dart';

abstract class UpdateEmiRepository {
  Future<EmiPaymentDetailModel> fetchEmiDetails();
  Future<bool> updateEmi(EmiUpdateEntity emiEntity);
  Future<bool> submitUpdate(Map<String, dynamic> payload);
}