import '../../domain/entities/qr_user_entity.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_remote_data_source.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remoteDataSource;

  QrRepositoryImpl(this.remoteDataSource);

  @override
  Future<QrUserEntity> validateKey({required String apiKey}) async {
    final model = await remoteDataSource.validateKey(apiKey: apiKey);
    return model;
  }

  @override
  Future<QrUserEntity> fetchQrData() async {
    final model = await remoteDataSource.fetchQrData();
    return model;
  }
}