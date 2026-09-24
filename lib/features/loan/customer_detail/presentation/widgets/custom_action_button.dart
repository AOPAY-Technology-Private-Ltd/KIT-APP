import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final Color textColor;

  const CustomActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.gradientColors,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(1.00, 0.50),
            end: const Alignment(0.00, 0.50),
            colors: gradientColors ??
                [const Color(0xFF022062), const Color(0xFF008EFD)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}