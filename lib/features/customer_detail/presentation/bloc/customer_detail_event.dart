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