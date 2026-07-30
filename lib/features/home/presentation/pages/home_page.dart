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
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: const HomeHeader(
        name: "Retailer Name",
        code: "Retailer Code",
      ),

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
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                20,
              ),
              children: [
                AvailableKitsCard(
                  available: data.availableKits,
                  total: data.totalKits,
                ),
                const SizedBox(height: 14),
                StatsGrid(
                  totalInstalled: data.totalInstalled,
                  locked: data.locked,
                  todayInstalled: data.todayInstalled,
                  overdue: data.overdue,
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
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}