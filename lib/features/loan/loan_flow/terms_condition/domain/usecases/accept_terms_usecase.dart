import '../entities/terms_entity.dart';
import '../repositories/terms_condition_repository.dart';

class AcceptTermsUsecase {
  final TermsConditionRepository repository;

  AcceptTermsUsecase(this.repository);

  Future<TermsEntity> call({required bool isAccepted}) async {
    return await repository.acceptTerms(isAccepted: isAccepted);
  }
}