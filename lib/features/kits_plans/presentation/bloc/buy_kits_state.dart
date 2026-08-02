part of 'buy_kits_bloc.dart';

class BuyKitsState {
  final List<PlanEntity> plans;
  final List<PaymentMethodEntity> paymentMethods;
  final PlanEntity selectedPlan;
  final String selectedPaymentMethodId;
  final double gstPercentage;
  final double subtotal;
  final double gstAmount;
  final double totalAmount;

  BuyKitsState({
    required this.plans,
    required this.paymentMethods,
    required this.selectedPlan,
    required this.selectedPaymentMethodId,
    required this.gstPercentage,
    required this.subtotal,
    required this.gstAmount,
    required this.totalAmount,
  });

  factory BuyKitsState.initial() {
    return BuyKitsState(
      plans: [],
      paymentMethods: [],
      selectedPlan: const PlanEntity(
        id: '',
        kitsCount: 0,
        price: 0.0,
        pricePerKit: 0.0,
      ),
      selectedPaymentMethodId: '',
      gstPercentage: 18.0,
      subtotal: 0.0,
      gstAmount: 0.0,
      totalAmount: 0.0,
    );
  }

  BuyKitsState copyWith({
    List<PlanEntity>? plans,
    List<PaymentMethodEntity>? paymentMethods,
    PlanEntity? selectedPlan,
    String? selectedPaymentMethodId,
    double? gstPercentage,
    double? subtotal,
    double? gstAmount,
    double? totalAmount,
  }) {
    return BuyKitsState(
      plans: plans ?? this.plans,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      selectedPaymentMethodId: selectedPaymentMethodId ?? this.selectedPaymentMethodId,
      gstPercentage: gstPercentage ?? this.gstPercentage,
      subtotal: subtotal ?? this.subtotal,
      gstAmount: gstAmount ?? this.gstAmount,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}