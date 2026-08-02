import 'package:flutter/material.dart';
import '../../domain/entities/plan_entity.dart';

class PlanCardWidget extends StatelessWidget {
  final PlanEntity plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0E9FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.black.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (plan.discountLabel != null || plan.isMostPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: plan.isMostPopular ? const Color(0xFF9333EA) : const Color(0xFFDCFCE7),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    plan.isMostPopular ? 'Most Popular' : plan.discountLabel!,
                    style: TextStyle(
                      color: plan.isMostPopular ? Colors.white : const Color(0xFF16A34A),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${plan.kitsCount} ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: isSelected ? const Color(0xFF2563EB) : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'kits',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            color: isSelected ? const Color(0xFF2563EB) : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₹${plan.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isSelected ? const Color(0xFF2563EB) : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${plan.pricePerKit} / kits',
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? const Color(0xFF2563EB).withValues(alpha: 0.7)
                          : Colors.black.withValues(alpha: 0.5),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}