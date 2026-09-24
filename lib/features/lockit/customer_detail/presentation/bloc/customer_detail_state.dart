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
  final Map<String, dynamic>? successDeviceActionsData;

  CustomerDetailLoaded({
    required this.customer,
    required this.appMaster,
    this.selectedTabIdx = 0,
    Map<String, bool>? actionToggles,
    Map<String, Map<String, bool>>? selectedSubItems,
    this.locationKitData,
    this.successDeviceActionsData,
  })  : actionToggles = actionToggles ?? _initActionToggles(appMaster, successDeviceActionsData),
        selectedSubItems = selectedSubItems ?? _initSelectedSubItems(appMaster, successDeviceActionsData);

  static Map<String, bool> _initActionToggles(AppMasterModel appMaster, Map<String, dynamic>? successActions) {
    Map<String, bool> toggles = {};
    for (var cat in appMaster.categories) {
      toggles[cat.actionName] = cat.check;
    }

    if (successActions != null) {
      final List dataList = successActions['data'] ?? successActions['Data'] ?? (successActions is List ? successActions : []);

      for (var actionItem in dataList) {
        if (actionItem is Map) {
          final String notificationCode = actionItem['notificationCode'] ?? actionItem['NotificationCode'] ?? '';
          final dynamic rawStatus = actionItem['actionStatus'] ?? actionItem['ActionStatus'] ?? actionItem['status'] ?? actionItem['Status'];

          bool actionStatus = false;
          if (rawStatus is bool) {
            actionStatus = rawStatus;
          } else if (rawStatus is String) {
            actionStatus = rawStatus.toUpperCase() == 'TRUE' || rawStatus.toUpperCase() == 'ENABLE' || rawStatus.toUpperCase() == '1';
          }

          for (var cat in appMaster.categories) {
            if (cat.notificationCode.toLowerCase() == notificationCode.toLowerCase()) {
              toggles[cat.actionName] = actionStatus;
            }
          }
        }
      }
    }
    return toggles;
  }

  static Map<String, Map<String, bool>> _initSelectedSubItems(AppMasterModel appMaster, Map<String, dynamic>? successActions) {
    Map<String, Map<String, bool>> subItems = {};

    for (var cat in appMaster.categories) {
      Map<String, bool> subMap = {};
      for (var sub in cat.subactionList) {
        subMap[sub.subactionName] = sub.active;
      }
      subItems[cat.actionName] = subMap;
    }

    if (successActions != null) {
      final List dataList = successActions['data'] ?? successActions['Data'] ?? (successActions is List ? successActions : []);

      for (var actionItem in dataList) {
        if (actionItem is Map) {
          final String notificationCode = actionItem['notificationCode'] ?? actionItem['NotificationCode'] ?? '';
          final List selectedApps = actionItem['selectedApps'] ?? actionItem['SelectedApps'] ?? [];

          for (var cat in appMaster.categories) {
            if (cat.notificationCode.toLowerCase() == notificationCode.toLowerCase()) {
              Map<String, bool> subMap = subItems[cat.actionName] ?? {};

              for (var app in selectedApps) {
                final String packageName = app['packageName'] ?? app['PackageName'] ?? '';
                final dynamic actionVal = app['actionStatus'] ?? app['ActionStatus'] ?? app['action'] ?? app['Action'];

                bool isActive = false;
                if (actionVal is bool) {
                  isActive = actionVal;
                } else if (actionVal is String) {
                  isActive = actionVal.toUpperCase() == 'TRUE' || actionVal.toUpperCase() == 'ENABLE' || actionVal.toUpperCase() == '1';
                }

                for (var sub in cat.subactionList) {
                  if (sub.packageName.toLowerCase() == packageName.toLowerCase() ||
                      sub.subactionName.toLowerCase() == packageName.toLowerCase()) {
                    subMap[sub.subactionName] = isActive;
                  }
                }
              }
              subItems[cat.actionName] = subMap;
            }
          }
        }
      }
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
    Map<String, dynamic>? successDeviceActionsData,
  }) {
    return CustomerDetailLoaded(
      customer: customer ?? this.customer,
      appMaster: appMaster ?? this.appMaster,
      selectedTabIdx: selectedTabIdx ?? this.selectedTabIdx,
      actionToggles: actionToggles ?? this.actionToggles,
      selectedSubItems: selectedSubItems ?? this.selectedSubItems,
      locationKitData: locationKitData ?? this.locationKitData,
      successDeviceActionsData: successDeviceActionsData ?? this.successDeviceActionsData,
    );
  }
}

class CustomerDetailError extends CustomerDetailState {
  final String message;
  CustomerDetailError(this.message);
}

class DeviceActionSuccessState extends CustomerDetailLoaded {
  final bool isLocked;
  final String message;

  DeviceActionSuccessState({
    required this.isLocked,
    required this.message,
    required super.customer,
    required super.appMaster,
    super.selectedTabIdx,
    super.actionToggles,
    super.selectedSubItems,
    super.locationKitData,
    super.successDeviceActionsData,
  });
}

class SaveDeviceActionSuccessState extends CustomerDetailState {
  final String message;
  SaveDeviceActionSuccessState({required this.message});
}