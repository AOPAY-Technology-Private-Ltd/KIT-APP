import 'package:flutter/material.dart';

class CustomHeaderIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const CustomHeaderIconButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: 25,
        height: 25,
        padding: const EdgeInsets.all(3),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}