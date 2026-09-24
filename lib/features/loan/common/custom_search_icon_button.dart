import 'package:flutter/material.dart';

class CustomSearchIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double size;

  const CustomSearchIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CustomPaint(
        painter: const GlassBorderPainter(borderRadius: 50),
        child: Container(
          height: size,
          width: size,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassBorderPainter extends CustomPainter {
  final double borderRadius;
  const GlassBorderPainter({this.borderRadius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.8),
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    if (borderRadius > 0) {
      canvas.drawRRect(rRect, paint);
    } else {
      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}