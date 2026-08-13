import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes/route_names.dart';
import '../../../../core/services/session_manager.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/available_kits_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_customers_section.dart';
import '../widgets/home_header.dart';
import 'all_customers_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _fullName = "";
  String _retailerCode = "";

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeDataEvent());
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
      body: BlocBuilder<HomeBloc, HomeState>(
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
                        context.read<HomeBloc>().add(LoadHomeDataEvent());
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
                : (data.retailerName.isNotEmpty ? data.retailerName : "Retailer Name");

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
                    HomeHeader(
                      name: displayName,
                      code: "Retailer ID · $activeRetailerCode ",
                    ),
                    Positioned(
                      top: 145,
                      left: 24,
                      right: 24,
                      child: AvailableKitsCard(
                        available: data.availableKits,
                        total: data.totalKits,
                        onViewInventory: () {
                          context.push(RouteNames.inventory);
                        },
                        onBuyMore: () {
                          context.push(RouteNames.buyKits);
                        },
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
                      StatsGrid(
                        totalInstalled: data.usedKits,
                        locked: data.lockedDevices,
                        todayInstalled: data.unlockedDevices,
                      ),
                      const SizedBox(height: 14),
                      QuickActionsSection(
                        onAddCustomerPressed: () {
                          context.push(RouteNames.createCustomer);
                        },
                      ),
                      const SizedBox(height: 14),
                      RecentCustomersSection(
                        customers: data.recentCustomers,
                        onSeeAllPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllCustomersScreen(),
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
}