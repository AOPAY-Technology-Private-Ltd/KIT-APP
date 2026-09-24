import 'package:flutter/material.dart';
import 'custom_icon_button.dart';
import 'custom_search_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;
  final List<Color> gradientColors;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onSearchPressed,
    this.gradientColors = const [Color(0xFF2563EB), Color(0xFF002577)],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 10),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomHeaderIconButton(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Transform(
                    transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.arrow_forward_ios, color: Color(0xFF2563EB), size: 14),
                        ],
                      ),
                    ),
                  ),
                ),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),

                CustomSearchIconButton(
                  size: 26,
                  onTap: onSearchPressed ?? () {},
                  child: const SizedBox(
                    width: 14,
                    height: 14,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}