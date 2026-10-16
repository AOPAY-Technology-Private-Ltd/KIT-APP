import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/custom_app_bar.dart';
import '../widgets/loan_customer_card.dart';
import '../bloc/loan_customer_bloc.dart';
import '../bloc/loan_customer_event.dart';
import '../bloc/loan_customer_state.dart';

class LoanCustomerListPage extends StatefulWidget {
  final String? initialStatus;

  const LoanCustomerListPage({super.key, this.initialStatus});

  @override
  State<LoanCustomerListPage> createState() => _LoanCustomerListPageState();
}

class _LoanCustomerListPageState extends State<LoanCustomerListPage> {
  final List<String> _filterOptions = ['All', 'Active', 'Overdue', 'Upcoming', 'Loan Not Created'];
  late String _selectedFilter;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialStatus != null && _filterOptions.contains(widget.initialStatus)) {
      _selectedFilter = widget.initialStatus!;
    } else {
      _selectedFilter = 'All';
    }

    _fetchCustomers();
  }

  void _fetchCustomers() {
    context.read<LoanCustomerBloc>().add(
      FetchLoanCustomersEvent(status: _selectedFilter, search: _searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<LoanCustomerBloc>().add(
      FetchLoanCustomersEvent(status: _selectedFilter, search: query),
    );
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
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _onSearchChanged('');
                }
              });
            },
          ),

          if (_isSearching)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search customer by name, mobile...',
                  hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.30), fontSize: 13, fontFamily: 'Inter'),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                        _onSearchChanged('');
                      });
                    },
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
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
                          items: _filterOptions.map((String value) {
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
                                FetchLoanCustomersEvent(status: newValue, search: _searchController.text),
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
                          padding: EdgeInsets.only(top: 60),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is LoanCustomerLoadedState) {
                      if (state.customers.isEmpty) {
                        return _buildEmptyStateWidget();
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

  Widget _buildEmptyStateWidget() {
    final bool hasSearchQuery = _searchController.text.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasSearchQuery ? Icons.search_off_rounded : Icons.person_search_rounded,
              size: 48,
              color: const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            hasSearchQuery ? 'No Results Found' : 'No Records Available',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 8),

          Text(
            hasSearchQuery
                ? 'We couldn\'t find any customer matching "${_searchController.text.trim()}". Try searching with a different keyword.'
                : 'There are currently no customers under the "$_selectedFilter" category.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF64748B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 20),

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              side: const BorderSide(color: Color(0xFF2563EB), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (hasSearchQuery) {
                setState(() {
                  _searchController.clear();
                });
              }
              _fetchCustomers();
            },
            icon: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF2563EB)),
            label: Text(
              hasSearchQuery ? 'Clear Search' : 'Refresh List',
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}