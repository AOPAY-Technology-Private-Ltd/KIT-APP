import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CreateLoanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyPanEvent extends CreateLoanEvent {
  final String panNumber;

  VerifyPanEvent(this.panNumber);

  @override
  List<Object?> get props => [panNumber];
}

class VerifyAadhaarEvent extends CreateLoanEvent {
  final String aadhaarNumber;
  final String firstName;
  final String? lastName;
  final String? mobileNumber;

  VerifyAadhaarEvent(
      this.aadhaarNumber, {
        required this.firstName,
        this.lastName,
        this.mobileNumber,
      });

  @override
  List<Object?> get props => [
    aadhaarNumber,
    firstName,
    lastName,
    mobileNumber,
  ];
}

class GetCreditReportEvent extends CreateLoanEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String dateOfBirth;
  final String emailId;
  final String panNumber;
  final String aadhaarNumber;
  final String otp;
  final String consentMessage;
  final String consentAcceptance;
  final String? primaryOtp;
  final String? address;
  final String? pinCode;
  final String? stateName;
  final String? cityName;
  final File? customerPhoto;
  final File? panPhoto;
  final File? frontImage;
  final File? backImage;

  GetCreditReportEvent({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.emailId,
    required this.panNumber,
    required this.aadhaarNumber,
    required this.otp,
    required this.consentMessage,
    required this.consentAcceptance,
    this.primaryOtp,
    this.address,
    this.pinCode,
    this.stateName,
    this.cityName,
    this.customerPhoto,
    this.panPhoto,
    this.frontImage,
    this.backImage,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    mobileNumber,
    dateOfBirth,
    emailId,
    panNumber,
    aadhaarNumber,
    otp,
    consentMessage,
    consentAcceptance,
    primaryOtp,
    address,
    pinCode,
    stateName,
    cityName,
    customerPhoto,
    panPhoto,
    frontImage,
    backImage,
  ];
}

class SubmitDocumentsEvent extends CreateLoanEvent {
  final File? customerPhoto;
  final String dob;
  final String? panNumber;
  final File? panPhoto;
  final String? aadhaarNumber;
  final File? frontImage;
  final File? backImage;
  final String firstName;
  final String? lastName;
  final String? mobileNumber;
  final String? emailId;
  final String? primaryOtp;
  final String? address;
  final String? pinCode;
  final String? stateName;
  final String? cityName;

  SubmitDocumentsEvent({
    required this.customerPhoto,
    required this.dob,
    this.panNumber,
    this.panPhoto,
    this.aadhaarNumber,
    this.frontImage,
    this.backImage,
    required this.firstName,
    this.lastName,
    this.mobileNumber,
    this.emailId,
    this.primaryOtp,
    this.address,
    this.pinCode,
    this.stateName,
    this.cityName,
  });

  @override
  List<Object?> get props => [
    customerPhoto,
    dob,
    panNumber,
    panPhoto,
    aadhaarNumber,
    frontImage,
    backImage,
    firstName,
    lastName,
    mobileNumber,
    emailId,
    primaryOtp,
    address,
    pinCode,
    stateName,
    cityName,
  ];
}