import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../core/services/session_manager.dart';
import '../../data/models/plan_model.dart';
import '../../data/models/payment_gateway_request_model.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/usecaes/buy_kits_usecases.dart';
import '../../domain/usecaes/trigger_payment_gateway_usecase.dart';

part 'buy_kits_event.dart';
part 'buy_kits_state.dart';

class BuyKitsBloc extends Bloc<BuyKitsEvent, BuyKitsState> {
  final GetBuyKitsDataUseCase getBuyKitsDataUseCase;
  final TriggerPaymentGatewayUseCase triggerPaymentGatewayUseCase;

  BuyKitsBloc(
      this.getBuyKitsDataUseCase,
      this.triggerPaymentGatewayUseCase,
      ) : super(BuyKitsState.initial()) {
    on<LoadBuyKitsData>(_onLoadBuyKitsData);
    on<SelectPlanEvent>(_onSelectPlan);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
    on<SubmitPaymentEvent>(_onSubmitPayment);
  }

  Future<void> _onLoadBuyKitsData(LoadBuyKitsData event, Emitter<BuyKitsState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, paymentFormHtml: null));
    try {
      final data = await getBuyKitsDataUseCase.execute();
      final plans = data['plans'] as List<PlanEntity>;
      final paymentMethods = data['paymentMethods'] as List<PaymentMethodEntity>;

      if (plans.isNotEmpty) {
        final initialPlan = plans.first;
        final subtotal = initialPlan.price;
        final gstAmount = subtotal * (state.gstPercentage / 100);
        final totalAmount = subtotal + gstAmount;

        emit(state.copyWith(
          isLoading: false,
          plans: plans,
          paymentMethods: paymentMethods,
          selectedPlan: initialPlan,
          selectedPaymentMethodId: paymentMethods.isNotEmpty ? paymentMethods.first.id : '',
          subtotal: subtotal,
          gstAmount: gstAmount,
          totalAmount: totalAmount,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          plans: [],
          paymentMethods: [],
          selectedPlan: null,
          selectedPaymentMethodId: '',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        plans: [],
        paymentMethods: [],
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectPlan(SelectPlanEvent event, Emitter<BuyKitsState> emit) {
    final subtotal = event.plan.price;
    final gstAmount = subtotal * (state.gstPercentage / 100);
    final totalAmount = subtotal + gstAmount;

    emit(state.copyWith(
      selectedPlan: event.plan,
      subtotal: subtotal,
      gstAmount: gstAmount,
      totalAmount: totalAmount,
    ));
  }

  void _onSelectPaymentMethod(SelectPaymentMethodEvent event, Emitter<BuyKitsState> emit) {
    emit(state.copyWith(selectedPaymentMethodId: event.paymentMethodId));
  }

  Future<void> _onSubmitPayment(SubmitPaymentEvent event, Emitter<BuyKitsState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null, paymentFormHtml: null));
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';

      final plan = state.selectedPlan as PlanModel;

      final requestModel = PaymentGatewayRequestModel(
        payCustomerPhoneNo: event.phoneNo,
        customerEmailID: "bos.centerpvtltd@gmail.com",
        registrationID: "AOP-554",
        payCartAmount: state.totalAmount.toStringAsFixed(2),
        eMINumbers: "1",
        customerCode: event.customerCode,
        payCustomerName: event.customerName,
        loanCode: plan.planCode,
        retailerCode: retailerCode,
      );

      final result = await triggerPaymentGatewayUseCase.execute(requestModel);

      final String? htmlForm = result['PreparePOSTForm'];

      emit(state.copyWith(
        isSubmitting: false,
        paymentFormHtml: htmlForm,
      ));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}