import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/customer_detail_entity.dart';

class LoanDetailsCard extends StatelessWidget {
  final CustomerDetailEntity customer;

  const LoanDetailsCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.phone_android, color: Color(0xFF2563EB), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.loanType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    Text(customer.loanCategory, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  currencyFormat.format(customer.emiAmount),
                  style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFF1F5F9)),
          ),
          Row(
            children: [
              Expanded(child: _buildDetailTile('Loan Amount', currencyFormat.format(customer.loanAmount))),
              Expanded(child: _buildDetailTile('Down Payment', currencyFormat.format(customer.downPayment))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDetailTile('Start Date', customer.startDate)),
              Expanded(child: _buildDetailTile('End Date', customer.endDate)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('EMI Progress', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 13)),
              Text('${customer.paidEmiCount} of ${customer.totalEmiCount} Paid', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(customer.totalEmiCount, (index) {
              bool isPaid = index < customer.paidEmiCount;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: index < customer.totalEmiCount - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontFamily: 'Inter')),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'Inter')),
      ],
    );
  }
}