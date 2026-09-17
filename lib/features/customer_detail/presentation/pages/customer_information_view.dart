import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/customer_detail_bloc.dart';
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
        final bloc = sl<CustomerDetailBloc>();
        Future.microtask(() => bloc.add(FetchCustomerDetailEvent(customerMobile)));
        return bloc;
      },
      child: _CustomerInformationContent(customerMobile: customerMobile),
    );
  }
}

class _CustomerInformationContent extends StatelessWidget {
  final String customerMobile;

  const _CustomerInformationContent({required this.customerMobile});

  @override
  Widget build(BuildContext context) {
    final currentState = context.watch<CustomerDetailBloc>().state;
    final int currentTabIdx = currentState is CustomerDetailLoaded
        ? currentState.selectedTabIdx
        : (currentState is DeviceActionSuccessState ? currentState.selectedTabIdx : 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<CustomerDetailBloc, CustomerDetailState>(
          listener: (context, state) {
            if (state is DeviceActionSuccessState) {
              context.push(
                RouteNames.deviceStatusSuccess,
                extra: {
                  'isLocked': state.isLocked,
                },
              );
            } else if (state is CustomerDetailError) {
              final bloc = context.read<CustomerDetailBloc>();
              if (state is! CustomerDetailLoaded && bloc.cachedCustomer != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            final bloc = context.read<CustomerDetailBloc>();

            if (state is CustomerDetailLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF1D61E7)));
            } else if (state is CustomerDetailError && state is! CustomerDetailLoaded && state is! DeviceActionSuccessState && bloc.cachedCustomer == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off_rounded, color: Color(0xFFDC2626), size: 48),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          bloc.add(FetchCustomerDetailEvent(customerMobile));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is CustomerDetailLoaded || state is DeviceActionSuccessState || (state is CustomerDetailError && bloc.cachedCustomer != null)) {
              final customer = bloc.cachedCustomer ?? (state is CustomerDetailLoaded ? state.customer : (state as DeviceActionSuccessState).customer);
              final activeTabIdx = state is CustomerDetailLoaded
                  ? state.selectedTabIdx
                  : (state is DeviceActionSuccessState ? state.selectedTabIdx : currentTabIdx);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomHeader(
                            title: 'Customer Information',
                            showSearch: false,
                            onNotificationTap: () => context.push(RouteNames.notification),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    CustomerProfileCard(customer: customer),
                    const SizedBox(height: 18),
                    CustomerInfoTabsWidget(selectedTabIdx: activeTabIdx),
                    const SizedBox(height: 18),

                    if (activeTabIdx == 0)
                      CustomerDetailInfoCard(customer: customer)
                    else if (activeTabIdx == 1)
                      CustomerDeviceInfoCard(customer: customer)
                    else if (activeTabIdx == 2 && (state is CustomerDetailLoaded || state is DeviceActionSuccessState))
                        CustomerActionInfoCard(
                          customer: customer,
                          actionToggles: (state is CustomerDetailLoaded)
                              ? state.actionToggles
                              : (state as DeviceActionSuccessState).actionToggles,
                          appMaster: (state is CustomerDetailLoaded)
                              ? state.appMaster
                              : (state as DeviceActionSuccessState).appMaster,
                          selectedSubItems: (state is CustomerDetailLoaded)
                              ? state.selectedSubItems
                              : (state as DeviceActionSuccessState).selectedSubItems,
                        )
                      else if (activeTabIdx == 2)
                          const SizedBox.shrink()
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
                            child: const Text(
                              'Content coming soon',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),

                    if (activeTabIdx == 0) ...[
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