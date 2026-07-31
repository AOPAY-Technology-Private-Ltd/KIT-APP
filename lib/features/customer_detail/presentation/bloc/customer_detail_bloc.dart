import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer_detail_entity.dart';
import '../../domain/usecases/get_customer_detail_usecase.dart';
import 'customer_detail_event.dart';
import 'customer_detail_state.dart';

class CustomerDetailBloc extends Bloc<CustomerDetailEvent, CustomerDetailState> {
  final GetCustomerDetailUseCase getCustomerDetailUseCase;
  CustomerDetailEntity? _cachedCustomer;

  CustomerDetailBloc({required this.getCustomerDetailUseCase}) : super(CustomerDetailInitial()) {
    on<FetchCustomerDetailEvent>(_onFetchCustomerDetail);
    on<ChangeCustomerInfoTabEvent>(_onChangeTab);
    on<UpdateActionToggleEvent>(_onUpdateActionToggle);
    on<LockDeviceEvent>(_onLockDevice);
    on<UnlockDeviceEvent>(_onUnlockDevice);
  }

  Future<void> _onFetchCustomerDetail(
      FetchCustomerDetailEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    emit(CustomerDetailLoading());
    try {
      final customer = await getCustomerDetailUseCase(event.customerId);
      _cachedCustomer = customer;
      emit(CustomerDetailLoaded(customer: customer, selectedTabIdx: 0));
    } catch (e) {
      emit(CustomerDetailError(e.toString()));
    }
  }

  void _onChangeTab(
      ChangeCustomerInfoTabEvent event,
      Emitter<CustomerDetailState> emit,
      ) {
    if (_cachedCustomer != null && state is CustomerDetailLoaded) {
      final currentState = state as CustomerDetailLoaded;
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

  Future<void> _onLockDevice(
      LockDeviceEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    emit(CustomerDetailLoading());
    try {
      // TODO: Call your Lock Device API / UseCase here using event.customerId
      await Future.delayed(const Duration(milliseconds: 800));

      emit( DeviceActionSuccessState(
        isLocked: true,
        message: 'Phone Locked Successfully',
      ));
    } catch (e) {
      emit(CustomerDetailError(e.toString()));
    }
  }

  Future<void> _onUnlockDevice(
      UnlockDeviceEvent event,
      Emitter<CustomerDetailState> emit,
      ) async {
    emit(CustomerDetailLoading());
    try {
      // TODO: Call your Unlock Device API / UseCase here using event.customerId
      await Future.delayed(const Duration(milliseconds: 800));

      emit( DeviceActionSuccessState(
        isLocked: false,
        message: 'Phone Unlocked Successfully',
      ));
    } catch (e) {
      emit(CustomerDetailError(e.toString()));
    }
  }
}