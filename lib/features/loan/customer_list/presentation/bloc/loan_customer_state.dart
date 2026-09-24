import '../../domain/entities/loan_customer_entity.dart';

abstract class LoanCustomerState {}

class LoanCustomerInitialState extends LoanCustomerState {}

class LoanCustomerLoadingState extends LoanCustomerState {}

class LoanCustomerLoadedState extends LoanCustomerState {
  final List<LoanCustomerEntity> customers;
  LoanCustomerLoadedState(this.customers);
}

class LoanCustomerErrorState extends LoanCustomerState {
  final String message;
  LoanCustomerErrorState(this.message);
}