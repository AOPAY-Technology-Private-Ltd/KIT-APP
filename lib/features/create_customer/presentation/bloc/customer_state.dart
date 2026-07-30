import 'package:flutter/foundation.dart';
import '../../data/models/customer_response_model.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerSuccess extends CustomerState {
  final String message;
  final CustomerResponseModel? data;

  CustomerSuccess({
    required this.message,
    this.data,
  });
}

class CustomerFailure extends CustomerState {
  final String error;
  CustomerFailure({required this.error});
}