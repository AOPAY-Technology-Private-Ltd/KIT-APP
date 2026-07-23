import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String code;

  const HomeHeader({super.key, required this.name, required this.code});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  code,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.15)),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.15)),
          ),
        ],
      ),
    );
  }
}