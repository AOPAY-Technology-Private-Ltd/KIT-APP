import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes/route_names.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/available_kits_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_customers_section.dart';
import '../widgets/home_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEDEF),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is HomeLoadedState) {
            final data = state.homeData;

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const HomeHeader(
                      name: "Gupta’s Mobiles",
                      code: "Retailer ID · LK-40921 · Andheri West",
                    ),
                    Positioned(
                      top: 145,
                      left: 24,
                      right: 24,
                      child: AvailableKitsCard(
                        available: 128,
                        total: 200,
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
                        totalInstalled: data.totalInstalled,
                        locked: data.locked,
                        todayInstalled: data.todayInstalled,
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
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}