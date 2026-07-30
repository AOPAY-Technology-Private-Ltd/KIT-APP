import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  final VoidCallback? onAddCustomerPressed;

  const QuickActionsSection({
    super.key,
    this.onAddCustomerPressed,
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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildActionItem(
                "Alerts",
                Icons.error_outline,
                const Color(0xFF6B4EE6),
                const Color(0xFFECE6FF),
              ),
            ),
            Expanded(
              child: _buildActionItem(
                "Lock",
                Icons.lock_outline,
                Colors.red,
                Colors.red.shade50,
              ),
            ),
            Expanded(
              child: _buildActionItem(
                "Unlock",
                Icons.lock_open,
                Colors.green,
                Colors.green.shade50,
              ),
            ),
            Expanded(
              child: _buildActionItem(
                "Reports",
                Icons.bar_chart,
                const Color(0xFF4A90E2),
                const Color(0xFFE8F1FC),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _button("Buy Kits"),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _button(
                "Add Customer",
                onPressed: onAddCustomerPressed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _button(String text, {VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.21,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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