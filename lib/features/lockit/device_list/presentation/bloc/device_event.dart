abstract class DeviceEvent {}

class FetchDevicesEvent extends DeviceEvent {}

class SearchDevicesEvent extends DeviceEvent {
  final String query;
  SearchDevicesEvent(this.query);
}