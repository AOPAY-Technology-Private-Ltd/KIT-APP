import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_theme.dart';

import '../../../../../core/constants/routes/route_names.dart';
import '../../common/widgets/auth_button.dart';
import '../../common/widgets/auth_footer.dart';
import '../../common/widgets/auth_image_slider.dart';
import '../../common/widgets/auth_logo.dart';
import '../../common/widgets/curved_top_container.dart';
import '../widgets/otp_boxes.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationView extends StatefulWidget {
  final String mobile;

  const OtpVerificationView({
    super.key,
    required this.mobile,
  });

  @override
  State<OtpVerificationView> createState() =>
      _OtpVerificationViewState();
}

class _OtpVerificationViewState
    extends State<OtpVerificationView> {
  final TextEditingController otpController =
  TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  String get maskedMobile {
    if (widget.mobile.length <= 4) {
      return widget.mobile;
    }

    return "XXXXXX${widget.mobile.substring(
      widget.mobile.length - 4,
    )}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            final bool isKeyboardVisible = keyboardHeight > 0;
            final double imageSize = isKeyboardVisible
                ? 110.0
                : (width * .65).clamp(220.0, 300.0).toDouble();

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: AppTheme.loginGradient,
              ),
              child: Stack(
                children: [
                  if (!isKeyboardVisible)
                    Positioned(
                      top: height * .04,
                      left: 0,
                      right: 0,
                      child: const AuthLogo(),
                    ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    top: isKeyboardVisible ? height * .02 : height * .18,
                    left: (width - imageSize) / 2,
                    child: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: AuthImageSlider(
                        size: imageSize,
                      ),
                    ),
                  ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    left: -width * .36,
                    bottom: isKeyboardVisible ? keyboardHeight - 20 : 0,
                    child: SizedBox(
                      width: width * 1.76,
                      height: height * .48,
                      child: CurvedTopContainer(
                        curveHeight: .42,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: height * 0.08,
                            left: width * 0.41,
                            right: width * 0.41,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "OTP Verification",
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "We have Sent an OTP to ",
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    maskedMobile,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              OtpBoxes(
                                controller: otpController,
                              ),
                              const SizedBox(height: 20),
                              AuthButton(
                                title: "Continue",
                                onTap: () {
                                  final otp = otpController.text.trim();

                                  if (otp.length != 5) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please enter 5 digit OTP",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context.go(RouteNames.home);

                                },
                              ),
                              const SizedBox(height: 12),
                              const AuthFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}