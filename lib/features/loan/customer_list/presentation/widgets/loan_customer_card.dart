import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/routes/route_names.dart';
import '../../domain/entities/loan_customer_entity.dart';

class LoanCustomerCard extends StatelessWidget {
  final LoanCustomerEntity customer;

  const LoanCustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    Color badgeBgColor;
    Color badgeTextColor;
    String statusLabel = customer.status;

    if (statusLabel.toLowerCase() == 'overdue') {
      badgeBgColor = const Color(0xFFFEE2E2);
      badgeTextColor = const Color(0xFFDC2626);
    } else if (statusLabel.toLowerCase() == 'upcoming') {
      badgeBgColor = const Color(0xFFDBEAFE);
      badgeTextColor = const Color(0xFF2563EB);
    } else {
      badgeBgColor = const Color(0xFFE8F8EF);
      badgeTextColor = const Color(0xFF08A94F);
      statusLabel = 'On track';
    }

    return InkWell(
      onTap: () {
        context.push(
          RouteNames.customerDetailNew,
          extra: customer.loanId,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xFFC7CFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: AssetImage(
                      customer.profileImage.isNotEmpty
                          ? customer.profileImage
                          : "assets/images/profile.png",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              customer.name,
                              style: const TextStyle(
                                color: Color(0xFF172033),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            child: Text(
                              '${customer.phone}  •  ${customer.email}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: badgeBgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: ShapeDecoration(
                            color: badgeTextColor,
                            shape: const OvalBorder(),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            color: badgeTextColor,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDetailRow('Loan ID', customer.loanId),
                  const SizedBox(height: 8),
                  _buildDetailRow('Principal', '₹${customer.principal}'),
                  const SizedBox(height: 8),
                  _buildDetailRow('Monthly EMI', '₹${customer.monthlyEmi}'),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    statusLabel.toLowerCase() == 'on track' ? 'Next payment' : 'Due date',
                    customer.nextPaymentDate,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('EMIs remaining', customer.emIsRemaining),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.60),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}