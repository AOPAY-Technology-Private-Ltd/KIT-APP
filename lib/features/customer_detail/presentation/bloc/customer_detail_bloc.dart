import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/session_manager.dart';
import '../../domain/entities/customer_detail_entity.dart';
import '../../domain/usecases/get_customer_detail_usecase.dart';
import '../../domain/usecases/get_app_master_usecase.dart';
import 'customer_detail_state.dart';

class CustomerDetailBloc extends Bloc<CustomerDetailEvent, CustomerDetailState> {
  final GetCustomerDetailUseCase getCustomerDetailUseCase;
  final GetAppMasterUseCase getAppMasterUseCase;
  final dynamic remoteDataSource;
  CustomerDetailEntity? _cachedCustomer;
  Map<String, dynamic>? _latestLocationKitData;
  Map<String, dynamic>? _successDeviceActionsData;

  String? _lastEnteredPin;

  CustomerDetailEntity? get cachedCustomer => _cachedCustomer;
  Map<String, dynamic>? get latestLocationKitData => _latestLocationKitData;
  Map<String, dynamic>? get successDeviceActionsData => _successDeviceActionsData;

  CustomerDetailBloc({
    required this.getCustomerDetailUseCase,
    required this.getAppMasterUseCase,
    this.remoteDataSource,
  }) : super(CustomerDetailInitial()) {
    on<FetchCustomerDetailEvent>(_onFetchCustomerDetail);
    on<ChangeCustomerInfoTabEvent>(_onChangeTab);
    on<UpdateActionToggleEvent>(_onUpdateActionToggle);
    on<LockDeviceEvent>(_onLockDevice);
    on<UnlockDeviceEvent>(_onUnlockDevice);
    on<SaveDeviceActionEvent>(_onSaveDeviceAction);
  }

  Future<void> _onFetchCustomerDetail(
      FetchCustomerDetailEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    emit(CustomerDetailLoading());
    try {
      final customer = await getCustomerDetailUseCase(event.customerId);
      _cachedCustomer = customer;

      final appMaster = await getAppMasterUseCase(customer.customerCode);

      if (remoteDataSource != null && customer.customerCode.isNotEmpty) {
        try {
          final clientCode = await SessionManager.getClientCode() ?? '';
          _successDeviceActionsData = await remoteDataSource.getSuccessDeviceActions(
            customerCode: customer.customerCode,
            clientCode: clientCode,
          );

          // 👈 API se check karke status update kar rahe hain agar locked hai
          if (_successDeviceActionsData != null) {
            bool isApiLocked = false;
            final responseMap = _successDeviceActionsData!;

            if (responseMap['notificationCode'] == 'LOCK_DEVICE') {
              isApiLocked = responseMap['actionStatus'] == true;
            } else if (responseMap['data'] is List) {
              final list = responseMap['data'] as List;
              for (var item in list) {
                if (item['notificationCode'] == 'LOCK_DEVICE') {
                  isApiLocked = item['actionStatus'] == true;
                  break;
                }
              }
            }

            if (isApiLocked) {
              _cachedCustomer = _cachedCustomer!.copyWith(status: "Locked");
            }
          }
        } catch (_) {
          _successDeviceActionsData = {};
        }
      }

      if (remoteDataSource != null && customer.customerCode.isNotEmpty) {
        try {
          _latestLocationKitData = await remoteDataSource.getCustomerLatestLocationKit(customer.customerCode);
        } catch (_) {
          _latestLocationKitData = {};
        }
      }

      emit(CustomerDetailLoaded(
        customer: _cachedCustomer!,
        appMaster: appMaster,
        selectedTabIdx: 0,
        successDeviceActionsData: _successDeviceActionsData,
      ));
    } catch (e) {
      emit(CustomerDetailError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onChangeTab(
      ChangeCustomerInfoTabEvent event,
      Emitter<CustomerDetailState> emit,
      ) {
    if (_cachedCustomer != null && state is CustomerDetailLoaded) {
      final currentState = state as CustomerDetailLoaded;
      emit(currentState.copyWith(selectedTabIdx: event.tabIndex));
    } else if (_cachedCustomer != null && state is DeviceActionSuccessState) {
      final currentState = state as DeviceActionSuccessState;
      emit(currentState.copyWith(selectedTabIdx: event.tabIndex));
    }
  }

  void _onUpdateActionToggle(
      UpdateActionToggleEvent event,
      Emitter<CustomerDetailState> emit,
      ) {
    if (state is CustomerDetailLoaded) {
      final currentState = state as CustomerDetailLoaded;

      final updatedSubItems = Map<String, Map<String, bool>>.from(currentState.selectedSubItems);
      updatedSubItems[event.categoryTitle] = event.updatedSubItems;

      bool anySelected = event.updatedSubItems.values.any((element) => element);
      final updatedToggles = Map<String, bool>.from(currentState.actionToggles);
      updatedToggles[event.categoryTitle] = anySelected;

      emit(currentState.copyWith(
        actionToggles: updatedToggles,
        selectedSubItems: updatedSubItems,
      ));
    }
  }

  Future<void> _onSaveDeviceAction(
      SaveDeviceActionEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    if (event.devicePin != null && event.devicePin!.isNotEmpty) {
      _lastEnteredPin = event.devicePin;
    }

    final finalPin = event.devicePin ?? _lastEnteredPin ?? '';

    try {
      if (remoteDataSource != null) {
        final success = await remoteDataSource.saveAndNotifyDeviceAction(
          customerCode: event.customerCode,
          notificationCode: event.notificationCode,
          actionStatus: event.actionStatus,
          devicePin: finalPin,
          selectedApps: event.selectedApps,
        );

        if (success) {
          if (_cachedCustomer != null && (state is CustomerDetailLoaded || state is DeviceActionSuccessState)) {
            final current = state is CustomerDetailLoaded
                ? state as CustomerDetailLoaded
                : state as DeviceActionSuccessState;

            if (event.notificationCode == 'LOCK_DEVICE') {
              _cachedCustomer = _cachedCustomer!.copyWith(
                status: event.actionStatus ? "Locked" : "Approved",
              );
            }

            emit(DeviceActionSuccessState(
              isLocked: event.actionStatus,
              message: 'Device Action Saved Successfully',
              customer: _cachedCustomer!,
              appMaster: current.appMaster,
              selectedTabIdx: current.selectedTabIdx,
              actionToggles: current.actionToggles,
              selectedSubItems: current.selectedSubItems,
              locationKitData: current.locationKitData,
              successDeviceActionsData: current.successDeviceActionsData,
            ));
          }
        } else {
          emit(CustomerDetailError('Failed to complete device action'));
        }
      }
    } catch (e) {
      final cleanError = e.toString().replaceAll('Exception: ', '');
      emit(CustomerDetailError(cleanError));
    }
  }

  Future<void> _onLockDevice(
      LockDeviceEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (_cachedCustomer != null && (state is CustomerDetailLoaded || state is DeviceActionSuccessState)) {
        final current = state is CustomerDetailLoaded
            ? state as CustomerDetailLoaded
            : state as DeviceActionSuccessState;

        _cachedCustomer = _cachedCustomer!.copyWith(status: "Locked");

        emit(DeviceActionSuccessState(
          isLocked: true,
          message: 'Phone Locked Successfully',
          customer: _cachedCustomer!,
          appMaster: current.appMaster,
          selectedTabIdx: current.selectedTabIdx,
          actionToggles: current.actionToggles,
          selectedSubItems: current.selectedSubItems,
          locationKitData: current.locationKitData,
          successDeviceActionsData: current.successDeviceActionsData,
        ));
      }
    } catch (e) {
      emit(CustomerDetailError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUnlockDevice(
      UnlockDeviceEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      if (_cachedCustomer != null && (state is CustomerDetailLoaded || state is DeviceActionSuccessState)) {
        final current = state is CustomerDetailLoaded
            ? state as CustomerDetailLoaded
            : state as DeviceActionSuccessState;

        _cachedCustomer = _cachedCustomer!.copyWith(status: "Approved");

        emit(DeviceActionSuccessState(
          isLocked: false,
          message: 'Phone Unlocked Successfully',
          customer: _cachedCustomer!,
          appMaster: current.appMaster,
          selectedTabIdx: current.selectedTabIdx,
          actionToggles: current.actionToggles,
          selectedSubItems: current.selectedSubItems,
          locationKitData: current.locationKitData,
          successDeviceActionsData: current.successDeviceActionsData,
        ));
      }
    } catch (e) {
      emit(CustomerDetailError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}

// ==================== EVENTS ====================
abstract class CustomerDetailEvent {}

class FetchCustomerDetailEvent extends CustomerDetailEvent {
  final String customerId;
  FetchCustomerDetailEvent(this.customerId);
}

class ChangeCustomerInfoTabEvent extends CustomerDetailEvent {
  final int tabIndex;
  ChangeCustomerInfoTabEvent(this.tabIndex);
}

class UpdateActionToggleEvent extends CustomerDetailEvent {
  final String categoryTitle;
  final Map<String, bool> updatedSubItems;

  UpdateActionToggleEvent({
    required this.categoryTitle,
    required this.updatedSubItems,
  });
}

class LockDeviceEvent extends CustomerDetailEvent {
  final String customerId;
  LockDeviceEvent(this.customerId);
}

class UnlockDeviceEvent extends CustomerDetailEvent {
  final String customerId;
  UnlockDeviceEvent(this.customerId);
}

class SaveDeviceActionEvent extends CustomerDetailEvent {
  final String customerCode;
  final String notificationCode;
  final bool actionStatus;
  final String? devicePin;
  final List<Map<String, dynamic>>? selectedApps;

  SaveDeviceActionEvent({
    required this.customerCode,
    required this.notificationCode,
    required this.actionStatus,
    this.devicePin,
    this.selectedApps,
  });
}