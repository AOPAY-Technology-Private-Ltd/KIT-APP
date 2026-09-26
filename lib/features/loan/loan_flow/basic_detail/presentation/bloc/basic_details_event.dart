import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class BasicDetailsEvent extends Equatable {
  const BasicDetailsEvent();

  @override
  List<Object?> get props => [];
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
    this.emailId,
    this.address,
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