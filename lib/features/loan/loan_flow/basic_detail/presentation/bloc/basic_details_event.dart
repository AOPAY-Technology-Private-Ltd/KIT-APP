import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class BasicDetailsEvent extends Equatable {
  const BasicDetailsEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends BasicDetailsEvent {
  final String mobileNumber;
  const SendOtpEvent({required this.mobileNumber});

  @override
  List<Object?> get props => [mobileNumber];
}

class VerifyOtpEvent extends BasicDetailsEvent {
  final String mobileNumber;
  final String otp;
  const VerifyOtpEvent({required this.mobileNumber, required this.otp});

  @override
  List<Object?> get props => [mobileNumber, otp];
}

class VerifyAndSubmitEvent extends BasicDetailsEvent {
  final String mobileNumber;
  final String otp;
  final File? customerPhoto;
  final String firstName;
  final String lastName;
  final String? alternateNumber;
  final String? emailId;
  final String? address;
  final bool acceptTerms;

  const VerifyAndSubmitEvent({
    required this.mobileNumber,
    required this.otp,
    this.customerPhoto,
    required this.firstName,
    required this.lastName,
    this.alternateNumber,
    this.emailId,
    this.address,
    required this.acceptTerms,
  });

  @override
  List<Object?> get props => [
    mobileNumber,
    otp,
    customerPhoto,
    firstName,
    lastName,
    alternateNumber,
    emailId,
    address,
    acceptTerms,
  ];
}

class FetchCreditReportEvent extends BasicDetailsEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String dateOfBirth;
  final String emailId;
  final String panNumber;
  final String otp;
  final String consentMessage;
  final String consentAcceptance;

  const FetchCreditReportEvent({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.emailId,
    required this.panNumber,
    required this.otp,
    required this.consentMessage,
    required this.consentAcceptance,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    mobileNumber,
    dateOfBirth,
    emailId,
    panNumber,
    otp,
    consentMessage,
    consentAcceptance,
  ];
}

class SubmitBasicDetailsEvent extends BasicDetailsEvent {
  final File? customerPhoto;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String? alternateNumber;
  final String? emailId;
  final String? address;
  final bool acceptTerms;

  const SubmitBasicDetailsEvent({
    this.customerPhoto,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    this.alternateNumber,
    required this.emailId,
    required this.address,
    required this.acceptTerms,
  });

  @override
  List<Object?> get props => [
    customerPhoto,
    firstName,
    lastName,
    mobileNumber,
    alternateNumber,
    emailId,
    address,
    acceptTerms,
  ];
}