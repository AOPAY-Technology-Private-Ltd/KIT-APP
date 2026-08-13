import 'package:flutter/material.dart';

enum CustomerTabType { all, locked }

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
    return Row(
      children: [
        Expanded(
          child: _buildTabButton(
            title: 'All',
            tabType: CustomerTabType.all,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTabButton(
            title: 'Locked',
            tabType: CustomerTabType.locked,
          ),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
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
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2563EB),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}