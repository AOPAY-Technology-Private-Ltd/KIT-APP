import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

class UploadDashedCard extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  final String title;

  const UploadDashedCard({
    super.key,
    required this.file,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DottedBorderPainter(
          color: const Color(0xFF2563EB),
          strokeWidth: 1.3,
          dashWidth: 8.0,
          dashSpace: 5.0,
          borderRadius: 10.0,
        ),
        child: Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0x192563EB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: file != null
              ? Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(file!, width: 45, height: 45, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      file!.path.split('/').last,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.80),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'File uploaded successfully',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 22),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/upload.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.80),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'JPG, PNG or PDF (Max. 5MB)',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.40),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rRect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, distance + len),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}