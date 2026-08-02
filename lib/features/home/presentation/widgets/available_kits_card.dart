import 'package:flutter/material.dart';

class AvailableKitsCard extends StatelessWidget {
  final int available;
  final int total;
  final VoidCallback? onViewInventory;
  final VoidCallback? onBuyMore;

  const AvailableKitsCard({
    super.key,
    required this.available,
    required this.total,
    this.onViewInventory,
    this.onBuyMore,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = total > 0 ? (available / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF2563EB)),
              const SizedBox(width: 6),
              const Text(
                'AVAILABLE KITS',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$available',
                  style: const TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: ' / $total Total',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}