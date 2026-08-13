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

class SubmitPaymentEvent extends BuyKitsEvent {
  final String phoneNo;
  final String customerCode;
  final String customerName;

  SubmitPaymentEvent({
    required this.phoneNo,
    required this.customerCode,
    required this.customerName,
  });
}

class SearchBuyKitsEvent extends BuyKitsEvent {
  final String query;
  SearchBuyKitsEvent(this.query);
}