import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loan_report_bloc.dart';
import '../bloc/loan_report_event.dart';
import '../bloc/loan_report_state.dart';
import '../widgets/loan_report_card.dart';
import '../widgets/loan_report_summary_header.dart';

class LoanReportsScreen extends StatefulWidget {
  const LoanReportsScreen({super.key});

  @override
  State<LoanReportsScreen> createState() => _LoanReportsScreenState();
}

class _LoanReportsScreenState extends State<LoanReportsScreen> {
  final List<String> _filters = ['All', 'Active', 'Overdue', 'Closed', 'Settled'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<LoanReportBloc>().add(FetchLoanReportsEvent(status: 'All'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState({
    required String title,
    required String subtitle,
    required IconData icon,
    bool showResetButton = false,
    VoidCallback? onReset,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
                fontFamily: 'Inter',
              ),
            ),
            if (showResetButton && onReset != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Reset Filters',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: BlocBuilder<LoanReportBloc, LoanReportState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 24,
                ),
                decoration: const ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 0.00),
                    end: Alignment(0.50, 1.00),
                    colors: [Color(0xFF2563EB), Color(0xFF002577)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: ShapeDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Loan Reports',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'All Disbursed Loans',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: state is LoanReportLoadedState
                          ? LoanReportSummaryHeader(
                        totalCount: state.summary.totalDisbursedCount,
                        totalVolume: state.summary.totalVolume,
                      )
                          : const SizedBox(height: 50),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.trim().toLowerCase();
                            });
                          },
                          style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontFamily: 'Inter'),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.search, color: Colors.grey, size: 20),
                            hintText: 'Search by name, loan ID...',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Inter'),
                            border: InputBorder.none,
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFF2563EB), size: 20),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = state is LoanReportLoadedState && state.selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: const Color(0xFF2563EB),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (bool selected) {
                          if (selected) {
                            context.read<LoanReportBloc>().add(FetchLoanReportsEvent(status: filter));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<LoanReportBloc, LoanReportState>(
                  builder: (context, state) {
                    if (state is LoanReportLoadingState || state is LoanReportInitialState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is LoanReportErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red, fontFamily: 'Inter'),
                        ),
                      );
                    } else if (state is LoanReportLoadedState) {
                      final loans = state.summary.loans.where((loan) {
                        final nameMatch = loan.customerName.toLowerCase().contains(_searchQuery);
                        final idMatch = loan.loanId.toLowerCase().contains(_searchQuery);
                        return nameMatch || idMatch;
                      }).toList();

                      if (loans.isEmpty) {
                        if (_searchQuery.isNotEmpty) {
                          return _buildEmptyState(
                            title: 'No Matching Loans Found',
                            subtitle: 'We couldn\'t find any loan matching "$_searchQuery".',
                            icon: Icons.search_off_rounded,
                            showResetButton: true,
                            onReset: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          );
                        } else {
                          return _buildEmptyState(
                            title: 'No Loans Available',
                            subtitle: 'There are no loans found under the "${state.selectedFilter}" filter.',
                            icon: Icons.folder_open_rounded,
                            showResetButton: state.selectedFilter != 'All',
                            onReset: () {
                              context.read<LoanReportBloc>().add( FetchLoanReportsEvent(status: 'All'));
                            },
                          );
                        }
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: loans.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return LoanReportCard(loan: loans[index]);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

