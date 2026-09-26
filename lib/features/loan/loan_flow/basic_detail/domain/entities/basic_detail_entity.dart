import 'dart:io';

class BasicDetailEntity {
  final File? customerPhoto;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String? alternateNumber;
  final String? emailId;
  final String? address;
  final bool acceptTerms;

  BasicDetailEntity({
    this.customerPhoto,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    this.alternateNumber,
    this.emailId,
    this.address,
    required this.acceptTerms,
  });
}