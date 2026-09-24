import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/routes/route_names.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onAddCustomerPressed;
  final int availableKits;

  const QuickActionsSection({
    super.key,
    this.onAddCustomerPressed,
    required this.availableKits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push(RouteNames.loanCustomerList, extra: 'Active');
                      },
                      child: _buildActionItem(
                        "Active",
                        Icons.inventory_2_outlined,
                        const Color(0xFF6B4EE6),
                        const Color(0xFFECE6FF),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push(RouteNames.loanCustomerList, extra: 'Overdue');
                      },
                      child: _buildActionItem(
                        "Overdue",
                        Icons.lock_outline,
                        Colors.red,
                        Colors.red.shade50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push(RouteNames.loanCustomerList, extra: 'Upcoming');
                      },
                      child: _buildActionItem(
                        "Upcoming",
                        Icons.lock_open,
                        Colors.green,
                        Colors.green.shade50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.push(RouteNames.loanReports);
                      },
                      child: _buildActionItem(
                        "Reports",
                        Icons.bar_chart,
                        const Color(0xFF4A90E2),
                        const Color(0xFFE8F1FC),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context.push(RouteNames.buyKits);
                  },
                  icon: Image.asset(
                    'assets/images/loan.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  label: const Text(
                    'Loan',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (availableKits <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please buy kits first to add a customer!'),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      if (onAddCustomerPressed != null) {
                        onAddCustomerPressed!();
                      }
                    }
                  },
                  icon: Image.asset(
                    'assets/images/Lock.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  label: const Text(
                    'Pay EMI',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem(
      String title,
      IconData icon,
      Color iconColor,
      Color bgColor,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}