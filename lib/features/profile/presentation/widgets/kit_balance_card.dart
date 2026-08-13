import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes/route_names.dart';
import '../../domain/entities/profile_entity.dart';

class KitBalanceCard extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback? onBuyMorePressed;

  const KitBalanceCard({
    super.key,
    required this.profile,
    this.onBuyMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dynamic Data from Profile Entity (API Response ke mutabiq)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Kit Balance',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.80),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${profile.kitBalance}', // Dynamic Available/Kit Balance
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 26,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' / ${profile.totalKits} Total', // Dynamic Total Kits
                      style: TextStyle(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.7),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Buy More Button with Navigation
          GestureDetector(
            onTap: onBuyMorePressed ?? () {
              context.push(RouteNames.buyKits);
            },
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(1.00, 0.50),
                  end: Alignment(0.00, 0.50),
                  colors: [Color(0xFF022062), Color(0xFF2563EB)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Center(
                child: Text(
                  'Buy More →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}