import 'dart:io';

class DocumentEntity {
  final String? dob;
  final String? panNumber;
  final File? panPhoto;
  final String? aadhaarNumber;
  final File? frontImage;
  final File? backImage;

  DocumentEntity({
    this.dob,
    this.panNumber,
    this.panPhoto,
    this.aadhaarNumber,
    this.frontImage,
    this.backImage,
  });
}