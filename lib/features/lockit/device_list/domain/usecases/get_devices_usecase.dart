import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

class GetDevicesUseCase {
  final DeviceRepository repository;

  GetDevicesUseCase(this.repository);

  Future<List<DeviceEntity>> call() async {
    return await repository.getDevices();
  }
}