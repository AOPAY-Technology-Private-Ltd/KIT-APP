import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final bool showSearch;
  final bool showNotification;
  final bool showBackButton;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onSearchTap,
    this.onNotificationTap,
    this.showSearch = true,
    this.showNotification = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onBackPressed ?? () => context.pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],

        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(width: 12),

        if (showNotification) ...[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onNotificationTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        if (showSearch) ...[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onSearchTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ],
    );
  }
}