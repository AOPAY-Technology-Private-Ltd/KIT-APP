import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_datasource.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DeviceEntity>> getDevices() async {
    final deviceModels = await remoteDataSource.getDevices();
    return deviceModels;
  }
}