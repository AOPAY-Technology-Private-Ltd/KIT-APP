import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../../data/datasources/buy_kits_remote_data_source.dart';
import '../../data/repositories/buy_kits_repository_impl.dart';
import '../../domain/usecaes/buy_kits_usecases.dart';
import '../bloc/buy_kits_bloc.dart';
import '../widgtes/bill_breakdown_widget.dart';
import '../widgtes/payment_method_card.dart';
import '../widgtes/plan_card_widget.dart';

class BuyKitsScreen extends StatelessWidget {
  const BuyKitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyKitsBloc(
        GetBuyKitsDataUseCase(
          BuyKitsRepositoryImpl(
            BuyKitsRemoteDataSourceImpl(),
          ),
        ),
      )..add(LoadBuyKitsData()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<BuyKitsBloc, BuyKitsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const CustomHeader(
                    title: 'Buy Lock Kits',
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Choose a Plan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Save more on bigger bundles. GST 18% included at checkout.',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.50),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.45,
                    ),
                    itemCount: state.plans.length,
                    itemBuilder: (context, index) {
                      final plan = state.plans[index];
                      final isSelected = state.selectedPlan.id == plan.id;
                      return PlanCardWidget(
                        plan: plan,
                        isSelected: isSelected,
                        onTap: () {
                          BlocProvider.of<BuyKitsBloc>(context).add(SelectPlanEvent(plan));
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BillBreakdownWidget(
                    selectedPlan: state.selectedPlan,
                    gstPercentage: state.gstPercentage,
                    subtotal: state.subtotal,
                    gstAmount: state.gstAmount,
                    totalAmount: state.totalAmount,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pay Using',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.paymentMethods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final method = state.paymentMethods[index];
                      final isSelected = state.selectedPaymentMethodId == method.id;
                      return PaymentMethodCard(
                        method: method,
                        isSelected: isSelected,
                        onChanged: (val) {
                          if (val != null) {
                            BlocProvider.of<BuyKitsBloc>(context).add(SelectPaymentMethodEvent(val));
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BuyKitsBloc, BuyKitsState>(
          builder: (context, state) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF008EFD),
                        Color(0xFF022062),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pay ₹${state.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}