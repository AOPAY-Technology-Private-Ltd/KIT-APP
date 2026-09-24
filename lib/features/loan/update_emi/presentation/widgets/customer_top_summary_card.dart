import 'package:flutter/material.dart';

class CustomerTopSummaryCard extends StatelessWidget {
  const CustomerTopSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pinki Sethi',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'ID: PS10069 • +91 987•• ••210',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontFamily: 'Inter'),
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
                child: const Text(
                  'Active',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOAN ID', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      SizedBox(height: 2),
                      Text('LN-2026-10069', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('OUTSTANDING', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      SizedBox(height: 2),
                      Text('₹ 10,800', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current EMI\n₹ 2,250 / month', style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3)),
              Text('Next Due Date\n05 Oct, 2026', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}