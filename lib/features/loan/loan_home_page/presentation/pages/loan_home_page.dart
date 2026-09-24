import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/routes/route_names.dart';
import '../../../../../core/services/session_manager.dart';

import '../bloc/loan_home_bloc.dart';
import '../bloc/loan_home_event.dart';
import '../bloc/loan_home_state.dart';
import '../widgets/stats_grid.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_customers_section.dart';
import '../widgets/home_header.dart';
import 'loan_all_customers_screen.dart';

class LaonHomePage extends StatefulWidget {
  const LaonHomePage({super.key});

  @override
  State<LaonHomePage> createState() => _LaonHomePageState();
}

class _LaonHomePageState extends State<LaonHomePage> {
  String _fullName = "";
  String _retailerCode = "";
  final int _selectedToggleIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<LoanHomeBloc>().add(LoadHomeDataEvent());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firstName = await SessionManager.getFirstName() ?? "";
    final lastName = await SessionManager.getLastName() ?? "";
    final retailerCode = await SessionManager.getRetailerCode() ?? "";

    setState(() {
      _fullName = "$firstName $lastName".trim();
      _retailerCode = retailerCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEDEF),
      body: BlocBuilder<LoanHomeBloc, LoanHomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState || state is HomeInitialState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }

          if (state is HomeErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        context.read<LoanHomeBloc>().add(LoadHomeDataEvent());
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry', style: TextStyle(fontFamily: 'Inter')),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is HomeLoadedState) {
            final data = state.homeData;

            final displayName = _fullName.isNotEmpty
                ? _fullName
                : (data.retailerName.isNotEmpty ? data.retailerName : "Gupta’s Mobiles");

            final activeRetailerCode = _retailerCode.isNotEmpty
                ? _retailerCode
                : (data.retailerCode.isNotEmpty ? data.retailerCode : 'LK-40921');

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LoanHomeHeader(
                      name: displayName,
                      code: "Retailer ID · $activeRetailerCode",
                      selectedToggleIndex: _selectedToggleIndex,
                      onToggleChanged: (index) {
                        if (index == 0) {
                          context.go(RouteNames.home);
                        }
                      },
                    ),
                    Positioned(
                      top: 145,
                      left: 24,
                      right: 24,
                      child: WalletBalanceCard(
                        balance: "Rs ${data.walletBalance}",
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoanStatsGrid(
                        totalLoan: data.totalLoan,
                        closedLoan: data.closedLoan,
                        settledLoan: data.settledLoan,
                      ),
                      const SizedBox(height: 16),
                      QuickActionsSection(
                        availableKits: 0,
                        onAddCustomerPressed: () {
                          context.push(RouteNames.createCustomer);
                        },
                      ),
                      const SizedBox(height: 14),
                      LoanRecentCustomersSection(
                        customers: data.recentCustomers,
                        onSeeAllPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoanAllCustomersScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildStatCard({required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF2563EB)),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}