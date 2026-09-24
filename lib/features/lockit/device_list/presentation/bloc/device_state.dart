import '../../domain/entities/device_entity.dart';

abstract class DeviceState {}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<DeviceEntity> devices;
  final List<DeviceEntity> filteredDevices;

  DeviceLoaded({required this.devices, required this.filteredDevices});
}

class DeviceError extends DeviceState {
  final String message;
  DeviceError(this.message);
}