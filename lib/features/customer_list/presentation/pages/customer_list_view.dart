import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/customer_list_bloc.dart';
import '../bloc/customer_list_event.dart';
import '../bloc/customer_list_state.dart';
import '../widgets/customer_card_item.dart';
import '../widgets/customer_list_tabs.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerListBloc(
        getCustomerListUseCase: sl(),
      )..add(FetchCustomerListEvent()),
      child: const _CustomerListViewContent(),
    );
  }
}

class _CustomerListViewContent extends StatelessWidget {
  const _CustomerListViewContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const CustomHeader(title: 'Customer List'),
              const SizedBox(height: 18),

              BlocBuilder<CustomerListBloc, CustomerListState>(
                builder: (context, state) {
                  CustomerTabType currentTab = CustomerTabType.all;
                  if (state is CustomerListLoaded) {
                    currentTab = state.selectedTab;
                  }
                  return CustomerListTabs(
                    selectedTab: currentTab,
                    onTabChanged: (tabType) {
                      context.read<CustomerListBloc>().add(FilterCustomerTabEvent(tabType));
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<CustomerListBloc, CustomerListState>(
                  builder: (context, state) {
                    if (state is CustomerListLoading) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF1D61E7)));
                    } else if (state is CustomerListLoaded) {
                      if (state.displayedCustomers.isEmpty) {
                        return const Center(child: Text('No customers found'));
                      }
                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.displayedCustomers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final customer = state.displayedCustomers[index];
                          return CustomerCardItem(customer: customer);
                        },
                      );
                    } else if (state is CustomerListError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}