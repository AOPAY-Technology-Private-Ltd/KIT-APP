import 'package:flutter/material.dart';

class LoanStatsGrid extends StatelessWidget {
  final int totalLoan;
  final int closedLoan;
  final int settledLoan;

  const LoanStatsGrid({
    super.key,
    required this.totalLoan,
    required this.closedLoan,
    required this.settledLoan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildStatCard(
              totalLoan,
              "Total Loan",
              Icons.calendar_today_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              closedLoan,
              "Closed Loan",
              Icons.calendar_today_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              settledLoan,
              "Settled Loan",
              Icons.calendar_today_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(int count, String label, IconData icon) {
    final displayCount = count == 0 ? "-" : count.toString();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: const Color(0xFFD3E3FD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                padding: const EdgeInsets.all(5),
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.03, 0.00),
                    end: Alignment(1.02, 1.02),
                    colors: [Color(0xFF4C73FF), Color(0xFFAF76FF)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  displayCount,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF020617),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.60),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.20,
            ),
          ),
        ],
      ),
    );
  }
}