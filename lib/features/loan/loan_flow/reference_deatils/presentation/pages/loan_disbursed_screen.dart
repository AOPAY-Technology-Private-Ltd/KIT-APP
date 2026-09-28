import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';
import 'dart:math' as math;

class LoanDisbursedScreen extends StatelessWidget {
  const LoanDisbursedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFF022062),
          elevation: 0,
          leading: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CustomHeaderIconButton(
                child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF022062), size: 12),
                onTap: () {
                },
              ),
            ),
          ),
          title: const Text(
            'Add Customer',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: CustomSearchIconButton(
                  child: const Icon(Icons.notifications_none, color: Colors.white, size: 15),
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const StepProgressHeader(currentStep: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '8. Loan Disbursed',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 48),

                        Center(
                          child: SizedBox(
                            height: 180,
                            width: 180,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ...List.generate(8, (index) {
                                  double angle = (index * 45) * 3.1415926535 / 180;
                                  double radius = 70;
                                  return Transform.translate(
                                    offset: Offset(radius * cos(angle), radius * sin(angle)),
                                    child: Container(
                                      width: index % 2 == 0 ? 8 : 6,
                                      height: index % 2 == 0 ? 8 : 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                }),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF22C55E),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        const Center(
                          child: Text(
                            'Loan Disbursed\nSuccessfully',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: CustomGradientButton(
                      text: 'Ok',
                      onPressed: () {
                        context.go(RouteNames.loanMain);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double cos(double radian) => mathCos(radian);
  double sin(double radian) => mathSin(radian);
}

double mathCos(double val) => math.cos(val);
double mathSin(double val) => math.sin(val);