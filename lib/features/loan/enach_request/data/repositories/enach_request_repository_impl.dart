import '../../domain/entities/enach_request_entity.dart';
import '../../domain/repositories/enach_request_repository.dart';
import '../datasources/enach_request_local_data_source.dart';

class EnachRequestRepositoryImpl implements EnachRequestRepository {
  final EnachRequestLocalDataSource localDataSource;

  EnachRequestRepositoryImpl(this.localDataSource);

  @override
  Future<List<EnachRequestEntity>> getEnachRequests() async {
    final models = await localDataSource.fetchDummyRequests();
    return models;
  }
}