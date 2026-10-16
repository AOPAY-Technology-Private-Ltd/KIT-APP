import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/models/update_emi_request_model.dart';

class CustomerTopSummaryCard extends StatelessWidget {
  final EmiPaymentDetailModel? emiDetails;

  const CustomerTopSummaryCard({
    super.key,
    this.emiDetails,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLoanCompleted = emiDetails != null &&
        (emiDetails!.outstandingAmount <= 0 || emiDetails!.paidEmiCount >= emiDetails!.totalEmiCount);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryBlue,
            Color(0xFF1D4ED8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
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
                      'ID: ${emiDetails?.customerCode ?? 'N/A'}${emiDetails?.customerMobile != null && emiDetails!.customerMobile.isNotEmpty ? " • ${emiDetails!.customerMobile}" : ""}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
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
                  color: isLoanCompleted ? const Color(0xFF10B981) : Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isLoanCompleted ? (emiDetails?.loanStatus ?? 'Close') : (emiDetails?.customerStatus ?? 'Approved'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
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
                        style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        emiDetails?.loanCode ?? 'N/A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoanCompleted ? 'TOTAL PAID' : 'OUTSTANDING',
                        style: const TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isLoanCompleted
                            ? '₹ ${(emiDetails?.totalPaid ?? 0.0).toStringAsFixed(2)}'
                            : '₹ ${(emiDetails?.outstandingAmount ?? 0.0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (isLoanCompleted) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Loan Amount: ₹ ${(emiDetails?.loanAmount ?? 0.0).toStringAsFixed(2)} | ${emiDetails?.loanMessage.isNotEmpty == true ? emiDetails!.loanMessage : "All payable EMIs are completed."}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan Amount: ₹ ${(emiDetails?.loanAmount ?? 0.0).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Current EMI: ₹ ${(emiDetails?.emiAmount ?? 0.0).toStringAsFixed(2)} / mo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Next Due Date',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      (emiDetails?.nextDueDate != null && emiDetails!.nextDueDate.isNotEmpty)
                          ? emiDetails!.nextDueDate
                          : 'N/A',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}