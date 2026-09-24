import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class LoanReportSummaryHeader extends StatelessWidget {
  final int totalCount;
  final double totalVolume;

  const LoanReportSummaryHeader({
    super.key,
    required this.totalCount,
    required this.totalVolume,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Loans',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 6),
                Text(
                  '$totalCount Disbursed',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Volume',
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormat.format(totalVolume),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}