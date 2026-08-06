import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/customer_detail_bloc.dart';
import '../bloc/customer_detail_event.dart';
import '../bloc/customer_detail_state.dart';
import '../widgets/customer_actionInfo_card.dart';
import '../widgets/customer_profile_card.dart';
import '../widgets/customer_info_tabs.dart';
import '../widgets/customer_detail_info_card.dart';
import '../widgets/customer_device_info_card.dart';

class CustomerInformationView extends StatelessWidget {
  final String customerMobile;

  const CustomerInformationView({super.key, required this.customerMobile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CustomerDetailBloc(getCustomerDetailUseCase: sl());
        Future.microtask(() => bloc.add(FetchCustomerDetailEvent(customerMobile)));
        return bloc;
      },
      child: const _CustomerInformationContent(),
    );
  }
}

class _CustomerInformationContent extends StatelessWidget {
  const _CustomerInformationContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
          builder: (context, state) {
            if (state is CustomerDetailLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1D61E7)));
            } else if (state is CustomerDetailError) {
              return Center(child: Text(state.message));
            } else if (state is CustomerDetailLoaded) {
              final customer = state.customer;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: CustomHeader(title: 'Customer Information')),
                      ],
                    ),
                    const SizedBox(height: 18),
                    CustomerProfileCard(customer: customer),
                    const SizedBox(height: 18),
                    CustomerInfoTabsWidget(selectedTabIdx: state.selectedTabIdx),
                    const SizedBox(height: 18),

                    if (state.selectedTabIdx == 0)
                      CustomerDetailInfoCard(customer: customer)
                    else if (state.selectedTabIdx == 1)
                      CustomerDeviceInfoCard(customer: customer)
                    else if (state.selectedTabIdx == 2)
                        CustomerActionInfoCard(
                          customer: customer,
                          actionToggles: state.actionToggles,
                          selectedSubItems: state.selectedSubItems,
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            'Content for Tab ${state.selectedTabIdx} coming soon',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),

                    if (state.selectedTabIdx == 0) ...[
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGradientElevatedButton(
                              text: 'Signature',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildGradientElevatedButton(
                              text: 'Documents',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildGradientElevatedButton({required String text, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 0.80),
          end: Alignment(0.00, 0.20),
          colors: [Color(0xFF022062), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}