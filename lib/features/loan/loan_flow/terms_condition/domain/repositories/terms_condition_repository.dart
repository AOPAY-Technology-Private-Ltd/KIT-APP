import '../entities/terms_entity.dart';

abstract class TermsConditionRepository {
  Future<TermsEntity> acceptTerms({required bool isAccepted});
}