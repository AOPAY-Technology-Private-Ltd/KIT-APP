import '../entities/support_entity.dart';

abstract class SupportRepository {
  Future<List<FaqEntity>> getFaqs();
  Future<SupportInfoEntity> getSupportDetails();
}