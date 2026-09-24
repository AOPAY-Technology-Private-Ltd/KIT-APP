import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/routes/route_names.dart';
import '../../../common/custom_app_bar.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/customer_header_card.dart';
import '../widgets/loan_details_card.dart';
import '../widgets/custom_action_button.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(FetchCustomerDetailEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoadingState || state is CustomerInitialState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
              ),
            );
          } else if (state is CustomerLoadedState) {
            final data = state.customer;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Customer Detail',
                    onBackPressed: () => Navigator.pop(context),
                    onSearchPressed: () {
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: CustomerHeaderCard(customer: data),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Loan Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 12),

                        LoanDetailsCard(customer: data),

                        const SizedBox(height: 24),

                        CustomActionButton(
                          title: 'Update EMI',
                          onPressed: () {
                            context.push(
                              RouteNames.updateEmi,
                              extra: data,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomActionButton(
                          title: 'Send Reminder',
                          gradientColors: const [Color(0xFF022062), Color(0xFF008EFD)],
                          onPressed: () {},
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}