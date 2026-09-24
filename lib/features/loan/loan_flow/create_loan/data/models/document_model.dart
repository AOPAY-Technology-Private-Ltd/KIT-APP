import 'dart:io';
import '../../domain/entities/document_entity.dart';

class DocumentModel extends DocumentEntity {
  DocumentModel({
    required super.dob,
    required super.panNumber,
    required super.panPhoto,
    required super.aadhaarNumber,
    required super.frontImage,
    required super.backImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'dob': dob,
      'panNumber': panNumber,
      'panPhoto': panPhoto?.path,
      'aadhaarNumber': aadhaarNumber,
      'frontImage': frontImage?.path,
      'backImage': backImage?.path,
    };
  }
}