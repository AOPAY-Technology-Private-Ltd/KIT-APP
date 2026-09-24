import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/routes/route_names.dart';

class LoanHomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String code;
  final int selectedToggleIndex;
  final ValueChanged<int> onToggleChanged;

  const LoanHomeHeader({
    super.key,
    required this.name,
    required this.code,
    required this.selectedToggleIndex,
    required this.onToggleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      height: 220,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 12,
        left: 16,
        right: 16,
        bottom: 24,
      ),
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFF2563EB), Color(0xFF002576)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 26,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name.isEmpty ? "Retailer Name" : name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        code.isEmpty ? "Retailer Code" : code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.70),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  height: 32,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            debugPrint("Lockit Clicked from Loan Page");
                            onToggleChanged(0);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedToggleIndex == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Lockit',
                              style: TextStyle(
                                color: selectedToggleIndex == 0 ? const Color(0xFF2563EB) : Colors.white,
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            debugPrint("Loan Clicked from Loan Page");
                            onToggleChanged(1);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedToggleIndex == 1 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Loan',
                              style: TextStyle(
                                color: selectedToggleIndex == 1 ? const Color(0xFF2563EB) : Colors.white,
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              _iconButton(
                Icons.notifications_none,
                    () => context.push(RouteNames.notification),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: CustomPaint(
        painter: const GlassBorderPainter(borderRadius: 50),
        child: Container(
          height: 38,
          width: 38,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0x33D9D9D9),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220);
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