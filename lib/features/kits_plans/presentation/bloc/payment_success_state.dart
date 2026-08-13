
import '../../domain/entities/payment_success_entity.dart';

abstract class PaymentSuccessState {}

class PaymentSuccessInitialState extends PaymentSuccessState {}

class PaymentSuccessSavingState extends PaymentSuccessState {}

class PaymentSuccessLoadedState extends PaymentSuccessState {
  final PaymentSuccessEntity entity;
  PaymentSuccessLoadedState(this.entity);
}

class PaymentSuccessErrorState extends PaymentSuccessState {
  final String message;
  PaymentSuccessErrorState(this.message);
}