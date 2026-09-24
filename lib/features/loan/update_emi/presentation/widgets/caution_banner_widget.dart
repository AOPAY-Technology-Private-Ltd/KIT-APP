import 'package:flutter/material.dart';

class CautionBannerWidget extends StatelessWidget {
  const CautionBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFFD97706), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Caution: Paid status will update the customer\'s loan ledger and reflect in the next collection cycle.',
              style: TextStyle(color: Color(0xFF92400E), fontSize: 11, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}