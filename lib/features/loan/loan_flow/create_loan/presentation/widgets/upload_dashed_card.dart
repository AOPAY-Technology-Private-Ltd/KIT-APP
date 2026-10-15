
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
          strokeWidth: 1.5,
          dashWidth: 8.0,
          dashSpace: 5.0,
          borderRadius: 10.0,
        ),
        child: Container(
          width: double.infinity,
          height: file != null ? 180 : 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0x192563EB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: file != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          'Image uploaded successfully',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 10,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ],
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'JPG, PNG or PDF (Max. 5MB)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.4),
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
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rRect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final double end = (distance + dashWidth).clamp(
          0.0,
          metric.length,
        );

        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );

        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.borderRadius != borderRadius;
  }
}
