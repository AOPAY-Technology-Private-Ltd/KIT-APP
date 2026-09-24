import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BottomNavigationBar(
          currentIndex: currentIndex > 3 ? 0 : currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF133682),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            fontFamily: 'Inter',
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 0 ? Icons.home : Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 1 ? Icons.group : Icons.group_outlined),
              label: "Customer",
            ),
            BottomNavigationBarItem(
              icon: const SizedBox.shrink(),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 2 ? Icons.history : Icons.history_outlined),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(currentIndex == 3 ? Icons.person : Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}