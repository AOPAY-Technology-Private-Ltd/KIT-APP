import 'package:flutter/material.dart';

enum CustomerTabType { all, overdue, locked, upcoming }

class CustomerListTabs extends StatelessWidget {
  final CustomerTabType selectedTab;
  final ValueChanged<CustomerTabType> onTabChanged;

  const CustomerListTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabButton(
            title: 'All',
            tabType: CustomerTabType.all,
          ),
          const SizedBox(width: 8),

          _buildTabButton(
            title: 'Overdue',
            tabType: CustomerTabType.overdue,
          ),
          const SizedBox(width: 8),

          _buildTabButton(
            title: 'Locked',
            tabType: CustomerTabType.locked,
          ),
          const SizedBox(width: 8),

          _buildTabButton(
            title: 'Upcoming',
            tabType: CustomerTabType.upcoming,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required CustomerTabType tabType,
  }) {
    final bool isSelected = selectedTab == tabType;

    return GestureDetector(
      onTap: () => onTabChanged(tabType),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color(0xFF2563EB),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2563EB),
                fontSize: 12,
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