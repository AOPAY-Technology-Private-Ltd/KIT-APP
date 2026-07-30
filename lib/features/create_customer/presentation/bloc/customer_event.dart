import 'dart:io';

abstract class CustomerEvent {}

class KitVerifyRequested extends CustomerEvent {
  final String primaryMobileNumber;
  KitVerifyRequested({required this.primaryMobileNumber});
}

class ManageCustomerSubmitted extends CustomerEvent {
  final String firstName;
  final String lastName;
  final String primaryMobileNumber;
  final String? alternateMobileNumber;
  final String? emailID;
  final String? currentAddress;
  final File? profileImage;

  ManageCustomerSubmitted({
    required this.firstName,
    required this.lastName,
    required this.primaryMobileNumber,
    this.alternateMobileNumber,
    this.emailID,
    this.currentAddress,
    this.profileImage,
  });
}