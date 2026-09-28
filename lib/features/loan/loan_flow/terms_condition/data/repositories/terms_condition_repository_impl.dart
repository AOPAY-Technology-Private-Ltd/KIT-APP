import '../../domain/entities/terms_entity.dart';
import '../../domain/repositories/terms_condition_repository.dart';
import '../datasources/terms_condition_remote_datasource.dart';

class TermsConditionRepositoryImpl implements TermsConditionRepository {
  final TermsConditionRemoteDatasource remoteDatasource;

  TermsConditionRepositoryImpl(this.remoteDatasource);

  @override
  Future<TermsEntity> acceptTerms({required bool isAccepted}) async {
    final responseModel = await remoteDatasource.submitTerms(isAccepted: isAccepted);
    return responseModel;
  }
}