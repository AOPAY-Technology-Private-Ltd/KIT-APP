import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logkit/features/customer_detail/domain/entities/customer_detail_entity.dart';
import 'package:logkit/features/customer_detail/presentation/bloc/customer_detail_bloc.dart';
import 'package:logkit/features/customer_detail/presentation/bloc/customer_detail_event.dart';

import '../../../../core/constants/routes/route_names.dart';

class CustomerProfileCard extends StatefulWidget {
  final CustomerDetailEntity customer;

  const CustomerProfileCard({super.key, required this.customer});

  @override
  State<CustomerProfileCard> createState() => _CustomerProfileCardState();
}

class _CustomerProfileCardState extends State<CustomerProfileCard> {
  late bool isLocked;

  @override
  void initState() {
    super.initState();
    final status = widget.customer.status.toLowerCase();
    isLocked = status == 'locked' || status == 'lock';
  }

  void _showDeviceActionDialog({
    required BuildContext context,
    required bool isLockAction,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.asset(
                    'assets/images/lock.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isLockAction ? 'Lock this Device?' : 'Unlock this Device?',
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isLockAction
                      ? 'This Customer will loose full access to their phone immediately'
                      : 'This Customer will regain full access to their phone immediately',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLockAction
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF00B22D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isLockAction ? 'Lock' : 'Unlock',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  widget.customer.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.customer.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: isLocked ? const Color(0xFFDC2626) : const Color(0xFF0A7804),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isLocked ? 'Locked' : 'Unlocked',
                                style: TextStyle(
                                  color: isLocked ? const Color(0xFFDC2626) : const Color(0xFF0A7804),
                                  fontSize: 8,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.customer.customerCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('EMI : ₹${widget.customer.emiAmount}',
                    //         style: const TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 10,
                    //           fontFamily: 'Inter',
                    //           fontWeight: FontWeight.w400,
                    //         )),
                    //     Text('EMI Date : ${widget.customer.emiDate}',
                    //         style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildCardIcon(Icons.location_on_outlined),
                  const SizedBox(width: 12),
                  _buildCardIcon(Icons.notifications_active_outlined),
                ],
              ),
              CustomPaint(
                painter: const GlassBorderPainter(borderRadius: 45),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0x33D9D9D9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showDeviceActionDialog(
                            context: context,
                            isLockAction: false,
                            onConfirm: () {
                              context.read<CustomerDetailBloc>().add(
                                UnlockDeviceEvent(widget.customer.id.toString()),
                              );

                              context.push(
                                RouteNames.deviceStatusSuccess,
                                extra: {
                                  'isLocked': false,
                                  'customerName': widget.customer.name,
                                  'deviceName': 'Redmi Note 13',
                                  'reason': 'EMI Paid',
                                  'time': 'Today, 9:42 AM',
                                  'actionBy': 'Retailer',
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: ShapeDecoration(
                            color: !isLocked ? Colors.white : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            shadows: !isLocked
                                ? [
                              const BoxShadow(
                                color: Color(0x66000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_open,
                                size: 10,
                                color: !isLocked ? const Color(0xFF3B82F6) : Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Unlock',
                                style: TextStyle(
                                  color: !isLocked ? const Color(0xFF3B82F6) : Colors.white,
                                  fontSize: 8,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      GestureDetector(
                        onTap: () {
                          _showDeviceActionDialog(
                            context: context,
                            isLockAction: true,
                            onConfirm: () {
                              context.read<CustomerDetailBloc>().add(
                                LockDeviceEvent(widget.customer.id.toString()),
                              );

                              context.push(
                                RouteNames.deviceStatusSuccess,
                                extra: {
                                  'isLocked': true,
                                  'customerName': widget.customer.name,
                                  'deviceName': 'Redmi Note 13',
                                  'reason': 'EMI Overdue',
                                  'time': 'Today, 9:42 AM',
                                  'actionBy': 'Retailer',
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: ShapeDecoration(
                            color: isLocked ? const Color(0xFFDC2626) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            shadows: isLocked
                                ? [
                              const BoxShadow(
                                color: Color(0xBF000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.lock,
                                size: 10,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Lock',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardIcon(IconData icon) {
    return CustomPaint(
      painter: const GlassBorderPainter(borderRadius: 50),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.24),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
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