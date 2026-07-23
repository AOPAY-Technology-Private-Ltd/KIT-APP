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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: [
          _buildStatCard("$totalInstalled", "Total Installed", Icons.calendar_today_outlined),
          _buildStatCard("$locked", "Locked", Icons.calendar_today_outlined),
          _buildStatCard("$todayInstalled", "Today Installed", Icons.calendar_today_outlined),
          _buildStatCard("$overdue", "Overdue", Icons.calendar_today_outlined),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6B4EE6)),
              const SizedBox(width: 8),
              Text(
                count,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}