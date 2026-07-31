import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/customer_detail_bloc.dart';
import '../bloc/customer_detail_event.dart';

class CustomerInfoTabsWidget extends StatelessWidget {
  final int selectedTabIdx;

  const CustomerInfoTabsWidget({super.key, required this.selectedTabIdx});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabItem(context, 'Info', 0, selectedTabIdx),
          const SizedBox(width: 12),
          _buildTabItem(context, 'Device', 1, selectedTabIdx),
          const SizedBox(width: 12),
          _buildTabItem(context, 'Action', 2, selectedTabIdx),
          const SizedBox(width: 12),
          _buildTabItem(context, 'Loan', 3, selectedTabIdx),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String title, int tabIndex, int currentIdx) {
    final bool isSelected = currentIdx == tabIndex;
    return GestureDetector(
      onTap: () {
        context.read<CustomerDetailBloc>().add(ChangeCustomerInfoTabEvent(tabIndex));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2563EB), width: 1),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF2563EB),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}