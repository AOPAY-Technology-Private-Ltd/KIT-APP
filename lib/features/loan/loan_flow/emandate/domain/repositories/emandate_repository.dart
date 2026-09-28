import '../entities/emandate_entity.dart';

abstract class EmandateRepository {
  Future<void> submitEmandate(EmandateEntity entity);
}