import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loan_history_bloc.dart';
import '../bloc/loan_history_event.dart';
import '../bloc/loan_history_state.dart';
import '../widgtes/LoanHistoryCard.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String selectedStatus = 'All';
  String selectedSort = 'Newest First';

  @override
  void initState() {
    super.initState();
    context.read<LoanHistoryBloc>().add(FetchLoanHistoryEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: BlocBuilder<LoanHistoryBloc, LoanHistoryState>(
        builder: (context, state) {
          if (state is LoanHistoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoanHistoryErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is LoanHistoryLoadedState) {
            final portfolio = state.portfolio;

            var loanList = portfolio.loanList.where((loan) {
              final matchesStatus = selectedStatus == 'All' ||
                  loan.status.toLowerCase() == selectedStatus.toLowerCase();

              final query = _searchQuery.toLowerCase();
              final matchesSearch = _searchQuery.isEmpty ||
                  loan.name.toLowerCase().contains(query) ||
                  loan.status.toLowerCase().contains(query) ||
                  loan.disbursedAmount.toLowerCase().contains(query) ||
                  loan.tenure.toLowerCase().contains(query) ||
                  loan.disbursalDate.toLowerCase().contains(query);

              return matchesStatus && matchesSearch;
            }).toList();

            loanList.sort((a, b) {
              if (selectedSort == 'Newest First') {
                return b.disbursalDate.compareTo(a.disbursalDate);
              } else {
                return a.disbursalDate.compareTo(b.disbursalDate);
              }
            });

            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.50, -0.00),
                      end: Alignment(0.50, 1.00),
                      colors: [Color(0xFF2563EB), Color(0xFF002576)],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 13, 16, 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new, size: 12, color: Color(0xFF2563EB)),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(0.00, 0.00),
                                end: Alignment(1.00, 1.00),
                                colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Disbursed Portfolio',
                                      style: TextStyle(
                                        color: Color(0xFFE0F2FE),
                                        fontSize: 13,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${portfolio.activeLoansCount} Active',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '₹${portfolio.totalDisbursed.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Disbursed to date across ${portfolio.totalEntries} entries',
                                  style: const TextStyle(
                                    color: Color(0xFF93C5FD),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search by name, status, price, date...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12,
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: Color(0xFF9CA3AF)),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: loanList.isEmpty
                      ? const Center(
                    child: Text(
                      'No loan history found',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    ),
                  )
                      : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    children: [
                      const Text(
                        'RECENT DISBURSALS',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...loanList.map((loan) => LoanHistoryCard(
                        name: loan.name,
                        status: loan.status,
                        disbursedAmount: loan.disbursedAmount,
                        tenure: loan.tenure,
                        disbursalDate: loan.disbursalDate,
                      )),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}