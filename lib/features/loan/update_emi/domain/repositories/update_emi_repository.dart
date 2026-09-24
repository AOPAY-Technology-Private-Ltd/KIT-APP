
import '../entities/emi_customer_entity.dart';

abstract class UpdateEmiRepository {
  Future<bool> updateEmi(EmiUpdateEntity emiEntity);
}