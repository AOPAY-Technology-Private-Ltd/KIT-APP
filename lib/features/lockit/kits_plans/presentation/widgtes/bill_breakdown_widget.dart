import 'package:flutter/material.dart';
import '../../domain/entities/plan_entity.dart';

class BillBreakdownWidget extends StatelessWidget {
  final PlanEntity selectedPlan;
  final double gstPercentage;
  final double subtotal;
  final double gstAmount;
  final double totalAmount;

  const BillBreakdownWidget({
    super.key,
    required this.selectedPlan,
    required this.gstPercentage,
    required this.subtotal,
    required this.gstAmount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedPlan.kitsCount} Kits',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '₹${subtotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GST (${gstPercentage.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '₹${gstAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}