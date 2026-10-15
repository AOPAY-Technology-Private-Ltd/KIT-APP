import 'package:flutter/material.dart';
import '../../data/models/update_emi_request_model.dart';

class CustomerTopSummaryCard extends StatelessWidget {
  final EmiPaymentDetailModel? emiDetails;

  const CustomerTopSummaryCard({
    super.key,
    this.emiDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: emiDetails?.profileImage != null && emiDetails!.profileImage!.isNotEmpty
                    ? NetworkImage(emiDetails!.profileImage!) as ImageProvider
                    : const AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emiDetails?.customerName ?? 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: ${emiDetails?.customerCode ?? 'N/A'} • ${emiDetails?.customerMobile ?? ''}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  emiDetails?.customerStatus ?? 'Approved',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LOAN CODE',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        emiDetails?.loanCode ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OUTSTANDING',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹ ${(emiDetails?.outstandingAmount ?? 0.0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current EMI\n₹ ${(emiDetails?.emiAmount ?? 0.0).toStringAsFixed(2)} / month',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
              Text(
                'Next Due Date\n${(emiDetails?.nextDueDate != null && emiDetails!.nextDueDate.isNotEmpty) ? emiDetails!.nextDueDate : 'N/A'}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}