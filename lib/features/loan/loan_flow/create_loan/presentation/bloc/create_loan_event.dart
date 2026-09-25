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
  VerifyAadhaarEvent(this.aadhaarNumber);

  @override
  List<Object?> get props => [aadhaarNumber];
}

class SubmitDocumentsEvent extends CreateLoanEvent {
  final String dob;
  final String? panNumber;
  final File? panPhoto;
  final String? aadhaarNumber;
  final File? frontImage;
  final File? backImage;

  SubmitDocumentsEvent({
    required this.dob,
    this.panNumber,
    this.panPhoto,
    this.aadhaarNumber,
    this.frontImage,
    this.backImage,
  });

  @override
  List<Object?> get props => [dob, panNumber, panPhoto, aadhaarNumber, frontImage, backImage];
}