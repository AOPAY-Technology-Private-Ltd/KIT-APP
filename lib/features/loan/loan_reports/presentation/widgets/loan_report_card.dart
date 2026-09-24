import 'package:flutter/material.dart';
import '../../domain/entities/loan_report_entity.dart';

import 'package:intl/intl.dart';

class LoanReportCard extends StatelessWidget {
  final LoanReportEntity loan;

  const LoanReportCard({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    Color badgeBg;
    Color badgeText;

    switch (loan.status.toLowerCase()) {
      case 'overdue':
        badgeBg = const Color(0xFFFEE2E2);
        badgeText = const Color(0xFFDC2626);
        break;
      case 'settled':
        badgeBg = const Color(0xFFDBEAFE);
        badgeText = const Color(0xFF2563EB);
        break;
      case 'closed':
        badgeBg = const Color(0xFFF1F5F9);
        badgeText = const Color(0xFF64748B);
        break;
      default:
        badgeBg = const Color(0xFFE8F8EF);
        badgeText = const Color(0xFF08A94F);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.customerName,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID: ${loan.loanId} • Disbursed: ${loan.disbursementDate}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  loan.status,
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LOAN AMOUNT', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontFamily: 'Inter')),
                    const SizedBox(height: 2),
                    Text(currencyFormat.format(loan.loanAmount), style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TENURE', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontFamily: 'Inter')),
                    const SizedBox(height: 2),
                    Text(loan.tenure, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EMI', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontFamily: 'Inter')),
                    const SizedBox(height: 2),
                    Text('${currencyFormat.format(loan.emiAmount)}/mo', style: const TextStyle(color: Color(0xFF2563EB), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}