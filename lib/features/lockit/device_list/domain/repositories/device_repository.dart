import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<List<DeviceEntity>> getDevices();
}