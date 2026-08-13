import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeviceHeader extends StatelessWidget {
  const DeviceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF2563EB)),
          onPressed: () => context.pop(),
        ),
        const Text(
          'Select Device',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2563EB),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Color(0xFF2563EB)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF2563EB)),
          onPressed: () {},
        ),
      ],
    );
  }
}