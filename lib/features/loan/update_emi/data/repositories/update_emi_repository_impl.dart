import '../../domain/entities/emi_customer_entity.dart';
import '../../domain/repositories/update_emi_repository.dart';
import '../datasources/update_emi_remote_datasource.dart';
import '../models/update_emi_request_model.dart';

class UpdateEmiRepositoryImpl implements UpdateEmiRepository {
  final UpdateEmiRemoteDataSource remoteDataSource;

  UpdateEmiRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> updateEmi(EmiUpdateEntity emiEntity) async {
    final model = UpdateEmiModel.fromEntity(emiEntity);
    return await remoteDataSource.submitEmiUpdate(model);
  }
}