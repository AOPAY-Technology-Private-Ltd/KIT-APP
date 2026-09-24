import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_devices_usecase.dart';
import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final GetDevicesUseCase getDevicesUseCase;

  DeviceBloc({required this.getDevicesUseCase}) : super(DeviceInitial()) {
    on<FetchDevicesEvent>(_onFetchDevices);
    on<SearchDevicesEvent>(_onSearchDevices);
  }

  Future<void> _onFetchDevices(
      FetchDevicesEvent event,
      Emitter<DeviceState> emit,
      ) async {
    emit(DeviceLoading());
    try {
      final devices = await getDevicesUseCase();
      emit(DeviceLoaded(devices: devices, filteredDevices: devices));
    } catch (e) {
      emit(DeviceError(e.toString()));
    }
  }

  void _onSearchDevices(
      SearchDevicesEvent event,
      Emitter<DeviceState> emit,
      ) {
    if (state is DeviceLoaded) {
      final currentState = state as DeviceLoaded;
      final query = event.query.toLowerCase();

      final filtered = currentState.devices.where((device) {
        return device.modelName.toLowerCase().contains(query);
      }).toList();

      emit(DeviceLoaded(devices: currentState.devices, filteredDevices: filtered));
    }
  }
}