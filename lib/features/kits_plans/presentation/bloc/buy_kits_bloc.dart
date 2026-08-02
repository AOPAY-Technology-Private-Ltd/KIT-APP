import 'package:bloc/bloc.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/usecaes/buy_kits_usecases.dart';

part 'buy_kits_event.dart';
part 'buy_kits_state.dart';

class BuyKitsBloc extends Bloc<BuyKitsEvent, BuyKitsState> {
  final GetBuyKitsDataUseCase getBuyKitsDataUseCase;

  BuyKitsBloc(this.getBuyKitsDataUseCase) : super(BuyKitsState.initial()) {
    on<LoadBuyKitsData>(_onLoadBuyKitsData);
    on<SelectPlanEvent>(_onSelectPlan);
    on<SelectPaymentMethodEvent>(_onSelectPaymentMethod);
  }

  Future<void> _onLoadBuyKitsData(LoadBuyKitsData event, Emitter<BuyKitsState> emit) async {
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
          plans: plans,
          paymentMethods: paymentMethods,
          selectedPlan: initialPlan,
          selectedPaymentMethodId: paymentMethods.isNotEmpty ? paymentMethods.first.id : '',
          subtotal: subtotal,
          gstAmount: gstAmount,
          totalAmount: totalAmount,
        ));
      }
    } catch (e) {
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
}