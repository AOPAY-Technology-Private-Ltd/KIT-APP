import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes/route_names.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;
  final int kitsCount;
  final double totalPaid;
  final String paymentMethod;

  const PaymentSuccessScreen({
    super.key,
    required this.orderId,
    required this.kitsCount,
    required this.totalPaid,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 240,
                      height: 240,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/payment.gif',
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Title
                    const Text(
                      'Payment Successful',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '$kitsCount new lock Kits added to your inventory',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD0FFD1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.black.withValues(alpha: 0.20),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Order ID', orderId),
                          const SizedBox(height: 16),
                          _buildDetailRow('Kits', '$kitsCount'),
                          const SizedBox(height: 16),
                          _buildDetailRow('Total Paid', '₹ ${totalPaid.toStringAsFixed(2)}'),
                          const SizedBox(height: 16),
                          _buildDetailRow('Method', paymentMethod),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      height: 54,
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF008EFD),
                            Color(0xFF022062),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),


                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextButton(
                      onPressed: () {

                        context.go(RouteNames.home);

                      },
                      child: const Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}