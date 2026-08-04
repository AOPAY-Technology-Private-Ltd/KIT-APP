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
      child: const CustomerListContent(),
    );
  }
}

class CustomerListContent extends StatefulWidget {
  const CustomerListContent({super.key});

  @override
  State<CustomerListContent> createState() => _CustomerListContentState();
}

class _CustomerListContentState extends State<CustomerListContent> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

              CustomHeader(
                title: 'Customer List',
                onSearchTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      context.read<CustomerListBloc>().add(SearchCustomerEvent(''));
                    }
                  });
                },
              ),
              const SizedBox(height: 18),

              if (_isSearching) ...[
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (query) {
                    context.read<CustomerListBloc>().add(SearchCustomerEvent(query));
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, mobile, IMEI...',
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.black54),
                      onPressed: () {
                        _searchController.clear();
                        context.read<CustomerListBloc>().add(SearchCustomerEvent(''));
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF3F6FF),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],

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
                        return _buildEmptyState();
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF0FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Customers Found',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'No results match your search or selected filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}