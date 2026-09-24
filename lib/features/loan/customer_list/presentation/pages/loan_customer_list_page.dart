import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/custom_app_bar.dart';
import '../widgets/loan_customer_card.dart';
import '../bloc/loan_customer_bloc.dart';
import '../bloc/loan_customer_event.dart';
import '../bloc/loan_customer_state.dart';


class LoanCustomerListPage extends StatefulWidget {
  const LoanCustomerListPage({super.key});

  @override
  State<LoanCustomerListPage> createState() => _LoanCustomerListPageState();
}

class _LoanCustomerListPageState extends State<LoanCustomerListPage> {
  String _selectedFilter = 'Active';

  @override
  void initState() {
    super.initState();
    context.read<LoanCustomerBloc>().add(FetchLoanCustomersEvent(status: _selectedFilter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          CustomAppBar(
            title: 'Customer List',
            onBackPressed: () => Navigator.pop(context),
            onSearchPressed: () {
            },
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Loan customers',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        BlocBuilder<LoanCustomerBloc, LoanCustomerState>(
                          builder: (context, state) {
                            int count = 0;
                            if (state is LoanCustomerLoadedState) {
                              count = state.customers.length;
                            }
                            return Text(
                              '$count customers shown',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.50),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          isDense: true,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          items: ['Active', 'Overdue', 'Upcoming'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedFilter = newValue;
                              });
                              context.read<LoanCustomerBloc>().add(
                                FetchLoanCustomersEvent(status: newValue),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                BlocBuilder<LoanCustomerBloc, LoanCustomerState>(
                  builder: (context, state) {
                    if (state is LoanCustomerLoadingState) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is LoanCustomerLoadedState) {
                      if (state.customers.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text('No customers found'),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.customers.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return LoanCustomerCard(customer: state.customers[index]);
                        },
                      );
                    } else if (state is LoanCustomerErrorState) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(state.message, style: const TextStyle(color: Colors.red)),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}