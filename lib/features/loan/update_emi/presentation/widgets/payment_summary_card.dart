import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSummaryCard extends StatelessWidget {
  final double dueAmount;
  final double totalPaid;

  const PaymentSummaryCard({
    super.key,
    required this.dueAmount,
    required this.totalPaid,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT SUMMARY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DUE AMOUNT',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(dueAmount),
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDBEAFE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL PAID',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(totalPaid),
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}