import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/available_kits_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/recent_customers_section.dart';
import '../widgets/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoadedState) {
            final data = state.homeData;
            return Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF133682), Color(0xFF2558C8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(name: data.retailerName, code: data.retailerCode),
                        AvailableKitsCard(available: data.availableKits, total: data.totalKits),
                        const SizedBox(height: 6),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF7F9FC),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              StatsGrid(
                                totalInstalled: data.totalInstalled,
                                locked: data.locked,
                                todayInstalled: data.todayInstalled,
                                overdue: data.overdue,
                              ),
                              const QuickActionsSection(),
                              RecentCustomersSection(customers: data.recentCustomers),
                              const SizedBox(height: 90),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is HomeErrorState) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF133682),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF133682).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () {
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}