import 'package:flutter/material.dart';
import '../../domain/entities/customer_detail_entity.dart';

class CustomerDetailInfoCard extends StatelessWidget {
  final CustomerDetailEntity customer;

  const CustomerDetailInfoCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Full Name', value: customer.name),
          const SizedBox(height: 12),
          _InfoRow(label: 'Email', value: customer.email),
          const SizedBox(height: 12),
          _InfoRow(label: 'Mobile', value: customer.mobile),
          const SizedBox(height: 12),
          _InfoRow(label: 'IMEI', value: customer.imei),
          const SizedBox(height: 12),
          _InfoRow(label: 'Code', value: customer.customerCode),
          const SizedBox(height: 12),
          _InfoRow(label: 'Address', value: customer.address),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style:  TextStyle(color: Colors.black.withValues(alpha: 0.80),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,)),
        ),
        const Text(' :  ', style: TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(value, style:  TextStyle(color: Colors.black.withValues(alpha: 0.80),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,)),
        ),
      ],
    );
  }
}