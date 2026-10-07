import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/loan_history_bloc.dart';
import '../bloc/loan_history_state.dart';
import '../widgtes/LoanHistoryCard.dart';

class LoanHistoryScreen extends StatelessWidget {
  const LoanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy list for UI demonstration matching your screenshot
    final List<Map<String, String>> loanList = [
      {'name': 'Aarav Sharma', 'status': 'Active', 'amount': '₹1,20,000', 'tenure': '12 Months', 'date': '12 Oct 2023'},
      {'name': 'Priya Patel', 'status': 'Active', 'amount': '₹85,000', 'tenure': '9 Months', 'date': '05 Nov 2023'},
      {'name': 'Rajesh Kumar', 'status': 'Closed', 'amount': '₹1,50,000', 'tenure': '18 Months', 'date': '20 Jan 2023'},
      {'name': 'Ananya Iyer', 'status': 'Closed', 'amount': '₹50,000', 'tenure': '6 Months', 'date': '15 May 2023'},
      {'name': 'Vikram Singh', 'status': 'Disbursed', 'amount': '₹95,000', 'tenure': '12 Months', 'date': '01 Dec 2023'},
      {'name': 'Meera Nair', 'status': 'Active', 'amount': '₹2,00,000', 'tenure': '24 Months', 'date': '18 Aug 2023'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // 1. Header with Gradient Background
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
                    // Top App Bar Row
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

                    // Portfolio Card inside Header
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
                                child: const Text(
                                  '6 Active Loans',
                                  style: TextStyle(
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
                          const Text(
                            '₹7,00,000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Disbursed to date across 30 entries',
                            style: TextStyle(
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

          // 2. Search & Filter Section
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
                      decoration: InputDecoration(
                        hintText: 'Search payments...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // 3. Section Title & List of Cards
          Expanded(
            child: ListView(
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
                // Mapping through the list dynamically
                ...loanList.map((loan) => LoanHistoryCard(
                  name: loan['name']!,
                  status: loan['status']!,
                  disbursedAmount: loan['amount']!,
                  tenure: loan['tenure']!,
                  disbursalDate: loan['date']!,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}