part of 'buy_kits_bloc.dart';

abstract class BuyKitsEvent {}

class LoadBuyKitsData extends BuyKitsEvent {}

class SelectPlanEvent extends BuyKitsEvent {
  final PlanEntity plan;
  SelectPlanEvent(this.plan);
}

class SelectPaymentMethodEvent extends BuyKitsEvent {
  final String paymentMethodId;
  SelectPaymentMethodEvent(this.paymentMethodId);
}