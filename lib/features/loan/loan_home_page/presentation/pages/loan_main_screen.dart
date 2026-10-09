import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/injection.dart';

import '../../../../lockit/profile/presentation/bloc/profile_bloc.dart';
import '../../../../lockit/profile/presentation/bloc/profile_event.dart';
import '../../../../lockit/profile/presentation/pages/profile_screen.dart';

import '../../../customer_list/presentation/bloc/loan_customer_bloc.dart';
import '../../../customer_list/presentation/pages/loan_customer_list_page.dart';
import '../../../loan_flow/loan_history/presentation/bloc/loan_history_bloc.dart';
import '../../../loan_flow/loan_history/presentation/bloc/loan_history_event.dart';
import '../../../loan_flow/loan_history/presentation/pages/loan_history_screen.dart';

import 'loan_home_page.dart';

class LoanMainScreen extends StatefulWidget {
  const LoanMainScreen({super.key});

  @override
  State<LoanMainScreen> createState() => _LoanMainScreenState();
}

class _LoanMainScreenState extends State<LoanMainScreen> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic> && extra.containsKey('initialIndex')) {
      final targetIndex = extra['initialIndex'];
      if (_currentIndex != targetIndex) {
        setState(() {
          _currentIndex = targetIndex;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Exit App',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: Container(
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(1.00, 0.50),
                        end: Alignment(0.00, 0.50),
                        colors: [Color(0xFF022062), Color(0xFF008EFD)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }

    return false;
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const LaonHomePage();
      case 1:
        return BlocProvider(
          create: (_) => sl<LoanCustomerBloc>(),
          child: const LoanCustomerListPage(),
        );
      case 2:
        return BlocProvider(
          create: (_) => sl<LoanHistoryBloc>()..add(FetchLoanHistoryEvent()),
          child: const LoanHistoryScreen(),
        );
      case 3:
        return BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(FetchProfileEvent()),
          child: const ProfileScreen(),
        );
      default:
        return const LaonHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: _getCurrentPage(),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.black.withValues(alpha: 0.16),
                  ),
                  borderRadius: BorderRadius.circular(70),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 8,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, 'Home', Icons.home_outlined, Icons.home),
                  _buildNavItem(1, 'Customer', Icons.group_outlined, Icons.group),
                  _buildNavItem(2, 'History', Icons.history_outlined, Icons.history),
                  _buildNavItem(3, 'Profile', Icons.person_outline, Icons.person),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData unselectedIcon, IconData selectedIcon) {
    final bool isServiceSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: ShapeDecoration(
          color: isServiceSelected ? const Color(0xFF2563EB) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isServiceSelected ? selectedIcon : unselectedIcon,
              size: 22,
              color: isServiceSelected ? Colors.white : Colors.black.withValues(alpha: 0.60),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isServiceSelected ? Colors.white : Colors.black.withValues(alpha: 0.60),
                fontSize: 9,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}