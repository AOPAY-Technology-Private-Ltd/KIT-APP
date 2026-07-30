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
  final String? dob;
  final String? panNumber;
  final String? aadhaarNumber;
  final bool? forceInsert;

  final File? custAadhaarFrontPhotoFile;
  final File? custAadhaarBackPhotoFile;
  final File? custPanNumberPhotoFile;
  final File? custPhotoFile;

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
    this.dob,
    this.panNumber,
    this.aadhaarNumber,
    this.forceInsert,
    this.custAadhaarFrontPhotoFile,
    this.custAadhaarBackPhotoFile,
    this.custPanNumberPhotoFile,
    this.custPhotoFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'primaryMobileNumber': primaryMobileNumber ?? '',
      'FirstName': firstName ?? '',
      'LastName': lastName ?? '',
      'AlternateMobileNumber': alternateMobileNumber ?? '',
      'EMailID': emailID ?? '',
      'CurrentAddress': currentAddress ?? '',
      'PANNumber': panNumber ?? '',
      'AadhaarNumber': aadhaarNumber ?? '',
    };
  }
}