import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/constants/routes/route_names.dart';

import '../../../../../core/di/injection.dart';
import '../../common/widgets/auth_button.dart';
import '../../common/widgets/auth_footer.dart';
import '../../common/widgets/auth_logo.dart';
import '../../common/widgets/auth_image_slider.dart';
import '../../common/widgets/curved_top_container.dart';

import '../../verifyotp/bloc/otp_bloc.dart';
import '../../verifyotp/bloc/otp_event.dart';
import '../../verifyotp/bloc/otp_state.dart';
import '../../verifyotp/widgets/otp_boxes.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import '../widgets/already_login_link.dart';
import '../widgets/signup_text_field.dart';

class PersonalDetailsView extends StatefulWidget {
  final String businessName;
  final String businessType;
  final String? gstNumber;

  const PersonalDetailsView({
    super.key,
    required this.businessName,
    required this.businessType,
    this.gstNumber,
  });

  @override
  State<PersonalDetailsView> createState() =>
      _PersonalDetailsViewState();
}

class _PersonalDetailsViewState
    extends State<PersonalDetailsView> {
  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isMobileFilled = false;
  bool isEmailFilled = false;
  bool isMobileVerified = false;
  bool isEmailVerified = false;
  String otpVerifyType = "";

  @override
  void initState() {
    super.initState();
    mobileController.addListener(() {
      setState(() {
        isMobileFilled = mobileController.text.trim().isNotEmpty;
      });
    });

    emailController.addListener(() {
      setState(() {
        isEmailFilled = emailController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  String get maskedMobile {
    final mobile = mobileController.text.trim();
    if (mobile.length <= 4) {
      return mobile;
    }
    return "XXXXXX${mobile.substring(mobile.length - 4)}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Signup Failed"),
                ],
              ),
              content: Text(state.error),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
        else if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          context.go(RouteNames.home);
        } else if (state is OtpSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) => BlocProvider(
              create: (_) => sl<OtpBloc>(),
              child: BlocConsumer<OtpBloc, OtpState>(
                listener: (context, otpState) {
                  if (otpState is OtpSuccess) {
                    Navigator.pop(sheetContext);

                    setState(() {
                      if (otpVerifyType == "mobile") {
                        isMobileVerified = true;
                      }
                      if (otpVerifyType == "email") {
                        isEmailVerified = true;
                      }
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(otpState.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (otpState is OtpFailure) {
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      SnackBar(
                        content: Text(otpState.error),
                        backgroundColor: colorScheme.error,
                      ),
                    );
                  }
                },
                builder: (context, otpState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
                    ),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "OTP Verification",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                OtpBoxes(
                                  controller: otpController,
                                ),
                                const SizedBox(height: 24),
                                AuthButton(
                                  title: otpState is OtpLoading
                                      ? "Verifying..."
                                      : "Verify OTP",
                                  onTap: otpState is OtpLoading
                                      ? () {}
                                      : () {
                                    final otp = otpController.text.trim();

                                    if (otp.length != 4) {
                                      ScaffoldMessenger.of(sheetContext)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Please enter 4 digit OTP"),
                                        ),
                                      );
                                      return;
                                    }

                                    context.read<OtpBloc>().add(
                                      VerifyOtpPressed(
                                        mobileOrEmail:
                                        otpVerifyType == "mobile"
                                            ? mobileController
                                            .text
                                            .trim()
                                            : emailController
                                            .text
                                            .trim(),
                                        otp: otp,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final bool isKeyboardVisible = keyboardHeight > 0;
              final double imageSize = isKeyboardVisible ? 90.0 : 200.0;

              return Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.loginGradient,
                ),
                child: Stack(
                  children: [
                    if (!isKeyboardVisible)
                      Positioned(
                        top: height * 0.02,
                        left: 0,
                        right: 0,
                        child: const AuthLogo(),
                      ),

                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      top: isKeyboardVisible ? height * 0.01 : height * 0.16,
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
                      left: -width * 0.46,
                      bottom: isKeyboardVisible ? keyboardHeight - 10 : -10,
                      child: SizedBox(
                        width: width * 1.84,
                        height: height * 0.60,
                        child: const CurvedTopContainer(
                          curveHeight: 0.34,
                          child: SizedBox(),
                        ),
                      ),
                    ),

                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      bottom: isKeyboardVisible ? keyboardHeight + 5 : height * 0.04,
                      left: width * 0.06,
                      right: width * 0.06,
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Onboarding",
                                style: theme.textTheme.headlineSmall,
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              const Text(
                                "Personal Details",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SignupTextField(
                                label: "Full Name",
                                hint: "Enter Full Name",
                                requiredField: true,
                                controller: fullNameController,
                                validator: (val) {
                                  val = val?.trim() ?? "";
                                  if (val.isEmpty) {
                                    return "Full Name is required!";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  SignupTextField(
                                    label: "Mobile Number",
                                    hint: "Enter Mobile Number",
                                    requiredField: true,
                                    keyboardType: TextInputType.number,
                                    controller: mobileController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    validator: (val) {
                                      val = val?.trim() ?? "";

                                      if (val.isEmpty) {
                                        return "Mobile Number is required!";
                                      }

                                      if (val.length != 10) {
                                        return "Enter valid 10 digit mobile number";
                                      }

                                      return null;
                                    },
                                  ),
                                  Positioned(
                                    right: 12,
                                    top: 0,
                                    bottom: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isMobileVerified
                                              ? Icons.check_circle
                                              : Icons.cancel_outlined,
                                          color: isMobileVerified
                                              ? Colors.green
                                              : Colors.red,
                                          size: 12,
                                        ),
                                        if (!isMobileVerified &&
                                            isMobileFilled) ...[
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              if (mobileController.text
                                                  .trim()
                                                  .length ==
                                                  10) {
                                                setState(() {
                                                  otpVerifyType = "mobile";
                                                });

                                                context
                                                    .read<SignupBloc>()
                                                    .add(
                                                  SendOtpRequested(
                                                    mobileOrEmailID:
                                                    mobileController
                                                        .text
                                                        .trim(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              "Verify",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  SignupTextField(
                                    label: "Email",
                                    hint: "Enter Email",
                                    requiredField: true,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    validator: (val) {
                                      val = val?.trim() ?? "";

                                      if (val.isEmpty) {
                                        return "Email is required!";
                                      }

                                      return Validators.validateEmail(val);
                                    },
                                  ),
                                  Positioned(
                                    right: 12,
                                    top: 0,
                                    bottom: 0,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isEmailVerified
                                              ? Icons.check_circle
                                              : Icons.cancel_outlined,
                                          color: isEmailVerified
                                              ? Colors.green
                                              : Colors.red,
                                          size: 12,
                                        ),
                                        if (!isEmailVerified &&
                                            isEmailFilled) ...[
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              final error =
                                              Validators.validateEmail(
                                                emailController.text.trim(),
                                              );

                                              if (error == null) {
                                                setState(() {
                                                  otpVerifyType = "email";
                                                });

                                                context
                                                    .read<SignupBloc>()
                                                    .add(
                                                  SendOtpRequested(
                                                    mobileOrEmailID:
                                                    emailController
                                                        .text
                                                        .trim(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text(
                                              "Verify",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              AuthButton(
                                title: "Submit →",
                                onTap: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  // Yahan && ki jagah || lagana hai taaki agar ek bhi verify na ho toh rok le
                                  if (!isMobileVerified || !isEmailVerified) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please verify both mobile number and email before submit", // <--- Message bhi update kar diya
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final fullName = fullNameController.text.trim();

                                  final firstName = fullName;
                                  final lastName = fullName;

                                  context.read<SignupBloc>().add(
                                    SignupSubmitted(
                                      businessName: widget.businessName,
                                      businessType: widget.businessType,
                                      gstNumber: widget.gstNumber,
                                      firstName: firstName,
                                      lastName: lastName,
                                      mobile: mobileController.text.trim(),
                                      email: emailController.text.trim(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              AlreadyLoginLink(
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (!isKeyboardVisible)
                      const Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: AuthFooter(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}