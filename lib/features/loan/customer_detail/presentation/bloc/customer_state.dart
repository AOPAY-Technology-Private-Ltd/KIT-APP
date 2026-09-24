import '../../domain/entities/customer_detail_entity.dart';

abstract class CustomerState {}

class CustomerInitialState extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final CustomerDetailEntity customer;

  CustomerLoadedState({required this.customer});
}

class CustomerErrorState extends CustomerState {
  final String message;

  CustomerErrorState({required this.message});
}