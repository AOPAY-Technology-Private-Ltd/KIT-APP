import '../../domain/entities/emandate_entity.dart';
import '../../domain/repositories/emandate_repository.dart';
import '../datasources/emandate_remote_datasource.dart';
import '../models/emandate_model.dart';

class EmandateRepositoryImpl implements EmandateRepository {
  final EmandateRemoteDataSource remoteDataSource;

  EmandateRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitEmandate(EmandateEntity entity) async {
    final model = EmandateModel.fromEntity(entity);
    await remoteDataSource.submitEmandate(model);
  }
}