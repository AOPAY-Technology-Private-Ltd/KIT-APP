import 'package:flutter/material.dart';


class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final double height;

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width = 380,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(top: 5, left: 16, right: 5, bottom: 5),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 0.50),
          end: Alignment(0.00, 0.50),
          colors: [Color(0xFF022062), Color(0xFF008EFD)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}