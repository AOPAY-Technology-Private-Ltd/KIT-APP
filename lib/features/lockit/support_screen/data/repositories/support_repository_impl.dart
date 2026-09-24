import '../../domain/entities/support_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<FaqEntity>> getFaqs() async {
    final faqModels = await remoteDataSource.fetchFaqs();
    return faqModels;
  }

  @override
  Future<SupportInfoEntity> getSupportDetails() async {
    final supportInfoModel = await remoteDataSource.fetchSupportDetails();
    return supportInfoModel;
  }
}