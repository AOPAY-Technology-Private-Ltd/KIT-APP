import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';

class InventoryFiltersWidget extends StatelessWidget {
  final String currentFilter;

  const InventoryFiltersWidget({super.key, required this.currentFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              width: 1,
              color: Color(0xFF2563EB),
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFilterTab(context, 'All', 'all', currentFilter),
              _buildFilterTab(context, 'Available', 'available', currentFilter),
              _buildFilterTab(context, 'Used', 'used', currentFilter),
              _buildFilterTab(context, 'Closed', 'closed', currentFilter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTab(BuildContext context, String label, String statusKey, String currentFilter) {
    bool isSelected = currentFilter == statusKey;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          BlocProvider.of<InventoryBloc>(context).add(FilterInventoryEvent(statusKey));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.zero,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF2563EB),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}