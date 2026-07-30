import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final int totalInstalled;
  final int locked;
  final int todayInstalled;
  final int overdue;

  const StatsGrid({
    super.key,
    required this.totalInstalled,
    required this.locked,
    required this.todayInstalled,
    required this.overdue,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;

        if (isTablet) {
          return Row(
            children: [
              Expanded(child: _buildStatCard("$totalInstalled", "Total Installed", Icons.check_circle_outline)),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard("$locked", "Locked", Icons.lock_outline)),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard("$todayInstalled", "Today Installed", Icons.today_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard("$overdue", "Overdue", Icons.warning_amber_outlined)),
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard("$totalInstalled", "Total Installed", Icons.check_circle_outline)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard("$locked", "Locked", Icons.lock_outline)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildStatCard("$todayInstalled", "Today Installed", Icons.today_outlined)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard("$overdue", "Overdue", Icons.warning_amber_outlined)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: ShapeDecoration(
        color: const Color(0x33DAE9FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xCC2563EB),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            padding: const EdgeInsets.all(5),
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4C73FF), Color(0xFFAF76FF)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    color: Color(0xFF020617),
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.65),
                    fontSize: 10.5,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}