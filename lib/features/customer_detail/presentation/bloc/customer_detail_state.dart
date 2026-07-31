import '../../domain/entities/customer_detail_entity.dart';

abstract class CustomerDetailState {}

class CustomerDetailInitial extends CustomerDetailState {}

class CustomerDetailLoading extends CustomerDetailState {}

class CustomerDetailLoaded extends CustomerDetailState {
  final CustomerDetailEntity customer;
  final int selectedTabIdx;
  final Map<String, bool> actionToggles;
  final Map<String, Map<String, bool>> selectedSubItems;

  CustomerDetailLoaded({
    required this.customer,
    this.selectedTabIdx = 0,
    Map<String, bool>? actionToggles,
    Map<String, Map<String, bool>>? selectedSubItems,
  })  : actionToggles = actionToggles ?? {
    'Social Apps': false,
    'UPI Apps': false,
    'Gaming Apps': true,
    'Disable Call': false,
    'Disable Settings': false,
    'KIOSK Mode': false,
    'Disable Camera': false,
    'Reboot': false,
    'Airplane Mode': false,
    'App Hide': false,
    'SIM Remove Lock': false,
  },
        selectedSubItems = selectedSubItems ?? {
          'Social Apps': {'Whatsapp': false, 'Facebook': false, 'Instagram': false, 'Youtube': false, 'Snapchat': false, 'Linkedin': false},
          'UPI Apps': {'Google Pay': false, 'PhonePe': false, 'Paytm': false, 'BHIM': false, 'Amazon Pay': false, 'Cred': false},
          'Gaming Apps': {'PUBG Mobile': false, 'Free Fire': false, 'BGMI': false, 'Call of Duty': false, 'Ludo King': false, 'Subway Surfers': false},
          'Disable Call': {'Incoming Calls': false, 'Outgoing Calls': false, 'International Calls': false, 'Roaming Calls': false},
          'Disable Settings': {'App Settings': false, 'Network Settings': false, 'System Settings': false, 'Developer Options': false},
          'KIOSK Mode': {'Single App Mode': false, 'Multi App Mode': false, 'Notification Bar Lock': false, 'Power Button Lock': false},
          'Disable Camera': {'Front Camera': false, 'Rear Camera': false, 'Video Recording': false, 'QR Scanner': false},
          'Reboot': {'Force Restart': false, 'Safe Mode Reboot': false, 'Remote Shutdown': false},
          'Airplane Mode': {'Cellular Data': false, 'Wi-Fi': false, 'Bluetooth': false, 'GPS': false},
          'App Hide': {'Banking Apps': false, 'Private Vault': false, 'Social Media Apps': false, 'Hidden Folders': false},
          'SIM Remove Lock': {'SIM 1 Lock': false, 'SIM 2 Lock': false, 'E-SIM Lock': false, 'Network Lock': false},
        };

  CustomerDetailLoaded copyWith({
    CustomerDetailEntity? customer,
    int? selectedTabIdx,
    Map<String, bool>? actionToggles,
    Map<String, Map<String, bool>>? selectedSubItems,
  }) {
    return CustomerDetailLoaded(
      customer: customer ?? this.customer,
      selectedTabIdx: selectedTabIdx ?? this.selectedTabIdx,
      actionToggles: actionToggles ?? this.actionToggles,
      selectedSubItems: selectedSubItems ?? this.selectedSubItems,
    );
  }
}

class CustomerDetailError extends CustomerDetailState {
  final String message;
  CustomerDetailError(this.message);
}

class DeviceActionSuccessState extends CustomerDetailState {
  final bool isLocked;
  final String message;
   DeviceActionSuccessState({required this.isLocked, required this.message});
}