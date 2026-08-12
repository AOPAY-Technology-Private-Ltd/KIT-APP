part of 'buy_kits_bloc.dart';

class BuyKitsState {
  final List<PlanEntity> plans;
  final List<PaymentMethodEntity> paymentMethods;
  final PlanEntity? selectedPlan;
  final String selectedPaymentMethodId;
  final double gstPercentage;
  final double subtotal;
  final double gstAmount;
  final double totalAmount;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? paymentFormHtml;

  BuyKitsState({
    required this.plans,
    required this.paymentMethods,
    this.selectedPlan,
    required this.selectedPaymentMethodId,
    required this.gstPercentage,
    required this.subtotal,
    required this.gstAmount,
    required this.totalAmount,
    required this.isLoading,
    required this.isSubmitting,
    this.errorMessage,
    this.paymentFormHtml,
  });

  factory BuyKitsState.initial() {
    return BuyKitsState(
      plans: [],
      paymentMethods: [],
      selectedPlan: null,
      selectedPaymentMethodId: '',
      gstPercentage: 18.0,
      subtotal: 0.0,
      gstAmount: 0.0,
      totalAmount: 0.0,
      isLoading: true,
      isSubmitting: false,
      errorMessage: null,
      paymentFormHtml: null,
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
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? paymentFormHtml,
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
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      paymentFormHtml: paymentFormHtml,
    );
  }
}