import '../../data/models/app_master_model.dart';
import '../../domain/entities/customer_detail_entity.dart';

abstract class CustomerDetailState {}

class CustomerDetailInitial extends CustomerDetailState {}

class CustomerDetailLoading extends CustomerDetailState {}

class CustomerDetailLoaded extends CustomerDetailState {
  final CustomerDetailEntity customer;
  final AppMasterModel appMaster;
  final int selectedTabIdx;
  final Map<String, bool> actionToggles;
  final Map<String, Map<String, bool>> selectedSubItems;
  final Map<String, dynamic>? locationKitData;

  CustomerDetailLoaded({
    required this.customer,
    required this.appMaster,
    this.selectedTabIdx = 0,
    Map<String, bool>? actionToggles,
    Map<String, Map<String, bool>>? selectedSubItems,
    this.locationKitData,
  })  : actionToggles = actionToggles ?? _initActionToggles(appMaster),
        selectedSubItems = selectedSubItems ?? _initSelectedSubItems(appMaster);

  static Map<String, bool> _initActionToggles(AppMasterModel appMaster) {
    Map<String, bool> toggles = {};
    for (var cat in appMaster.categories) {
      toggles[cat.actionName] = cat.check;
    }
    return toggles;
  }

  static Map<String, Map<String, bool>> _initSelectedSubItems(AppMasterModel appMaster) {
    Map<String, Map<String, bool>> subItems = {};
    for (var cat in appMaster.categories) {
      Map<String, bool> subMap = {};
      for (var sub in cat.subactionList) {
        subMap[sub.subactionName] = sub.active;
      }
      subItems[cat.actionName] = subMap;
    }
    return subItems;
  }

  CustomerDetailLoaded copyWith({
    CustomerDetailEntity? customer,
    AppMasterModel? appMaster,
    int? selectedTabIdx,
    Map<String, bool>? actionToggles,
    Map<String, Map<String, bool>>? selectedSubItems,
    Map<String, dynamic>? locationKitData,
  }) {
    return CustomerDetailLoaded(
      customer: customer ?? this.customer,
      appMaster: appMaster ?? this.appMaster,
      selectedTabIdx: selectedTabIdx ?? this.selectedTabIdx,
      actionToggles: actionToggles ?? this.actionToggles,
      selectedSubItems: selectedSubItems ?? this.selectedSubItems,
      locationKitData: locationKitData ?? this.locationKitData,
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

class SaveDeviceActionSuccessState extends CustomerDetailState {
  final String message;
  SaveDeviceActionSuccessState({required this.message});
}