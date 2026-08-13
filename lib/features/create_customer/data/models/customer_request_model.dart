import 'dart:io';

class CustomerRequestModel {
  final String? mode;
  final String? firstName;
  final String? lastName;
  final String? primaryMobileNumber;
  final String? alternateMobileNumber;
  final String? primaryMobileVerified;
  final String? primaryOTP;
  final String? emailID;
  final String? currentAddress;
  final String? pinCode;
  final String? country;
  final String? stateName;
  final String? cityName;
  final String? imeiNumber1;
  final String? imeiNumber2;
  final String? dob;
  final String? panNumber;
  final String? aadhaarNumber;
  final bool? forceInsert;

  final File? custAadhaarFrontPhotoFile;
  final File? custAadhaarBackPhotoFile;
  final File? custPanNumberPhotoFile;
  final File? custPhotoFile;
  final File? imeiNumberPhotoFile;
  final File? imeiNumber1SealPhotoFile;
  final File? imeiNumber2SealPhotoFile;
  final File? invoiceFile;

  CustomerRequestModel({
    this.mode,
    this.firstName,
    this.lastName,
    this.primaryMobileNumber,
    this.alternateMobileNumber,
    this.primaryMobileVerified,
    this.primaryOTP,
    this.emailID,
    this.currentAddress,
    this.pinCode,
    this.country,
    this.stateName,
    this.cityName,
    this.imeiNumber1,
    this.imeiNumber2,
    this.dob,
    this.panNumber,
    this.aadhaarNumber,
    this.forceInsert,
    this.custAadhaarFrontPhotoFile,
    this.custAadhaarBackPhotoFile,
    this.custPanNumberPhotoFile,
    this.custPhotoFile,
    this.imeiNumberPhotoFile,
    this.imeiNumber1SealPhotoFile,
    this.imeiNumber2SealPhotoFile,
    this.invoiceFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'Mode': mode,
      'FirstName': firstName,
      'LastName': lastName,
      'PrimaryMobileNumber': primaryMobileNumber,
      'AlternateMobileNumber': alternateMobileNumber,
      'PrimaryMobileVerified': primaryMobileVerified,
      'PrimaryOTP': primaryOTP,
      'EMailID': emailID,
      'CurrentAddress': currentAddress,
      'PinCode': pinCode,
      'Country': country,
      'StateName': stateName,
      'CityName': cityName,
      'IMEINumber1': imeiNumber1,
      'IMEINumber2': imeiNumber2,
      'DOB': dob,
      'PANNumber': panNumber,
      'AadhaarNumber': aadhaarNumber,
      'ForceInsert': forceInsert,
    };
  }
}