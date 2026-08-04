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

  final String? panNumber;
  final File? panImage;
  final String? aadharNumber;
  final File? aadharFrontImage;
  final File? aadharBackImage;

  final String? imeiNumber1;
  final String? imeiNumber2;
  final File? imeiNumberPhotoFile;
  final File? imeiNumber1SealPhotoFile;
  final File? imeiNumber2SealPhotoFile;
  final File? invoiceFile;

  ManageCustomerSubmitted({
    required this.firstName,
    required this.lastName,
    required this.primaryMobileNumber,
    this.alternateMobileNumber,
    this.emailID,
    this.currentAddress,
    this.profileImage,
    this.panNumber,
    this.panImage,
    this.aadharNumber,
    this.aadharFrontImage,
    this.aadharBackImage,
    this.imeiNumber1,
    this.imeiNumber2,
    this.imeiNumberPhotoFile,
    this.imeiNumber1SealPhotoFile,
    this.imeiNumber2SealPhotoFile,
    this.invoiceFile,
  });
}