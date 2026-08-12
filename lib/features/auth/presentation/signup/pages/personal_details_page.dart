import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/validators.dart';
import '../../../../../../core/constants/routes/route_names.dart';

import '../../../../../core/di/injection.dart';
import '../../common/widgets/auth_button.dart';
import '../../common/widgets/auth_logo.dart';
import '../../common/widgets/auth_image_slider.dart';
import '../../common/widgets/curved_top_container.dart';

import '../../common/widgets/no_internet_widget.dart';
import '../../verifyotp/bloc/otp_bloc.dart';
import '../../verifyotp/bloc/otp_event.dart';
import '../../verifyotp/bloc/otp_state.dart';
import '../../verifyotp/widgets/otp_boxes.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
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
  State<PersonalDetailsView> createState() => _PersonalDetailsViewState();
}

class _PersonalDetailsViewState extends State<PersonalDetailsView> {
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

  bool isOtpSheetOpen = false;

  @override
  void initState() {
    super.initState();

    mobileController.addListener(() {
      setState(() {
        isMobileFilled = mobileController.text.trim().isNotEmpty;
        isMobileVerified = false;
      });
    });

    emailController.addListener(() {
      setState(() {
        isEmailFilled = emailController.text.trim().isNotEmpty;
        isEmailVerified = false;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          if (state.error.contains('No internet connection')) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        "Connection Error",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: NoInternetWidget(
                      onRetry: () {
                        if (!isMobileVerified || !isEmailVerified) {
                          Navigator.of(dialogContext, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please verify both mobile number and email before retry",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        Navigator.of(dialogContext, rootNavigator: true).pop();

                        if (!mounted) return;

                        final fullName = fullNameController.text.trim();
                        final emailText = emailController.text.trim();
                        final mobileText = mobileController.text.trim();

                        context.read<SignupBloc>().add(
                          SignupSubmitted(
                            businessName: widget.businessName,
                            businessType: widget.businessType,
                            gstNumber: widget.gstNumber,
                            firstName: fullName,
                            lastName: fullName,
                            mobile: mobileText,
                            email: emailText,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: const [],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          context.go(RouteNames.home);
        } else if (state is OtpSentSuccess) {
          if (isOtpSheetOpen) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            return;
          }

          setState(() {
            isOtpSheetOpen = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          String? bottomSheetError;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<OtpBloc>()),
                BlocProvider.value(
                  value: BlocProvider.of<SignupBloc>(context),
                ),
              ],
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return BlocConsumer<OtpBloc, OtpState>(
                    listener: (ctx, otpState) {
                      if (otpState is OtpSuccess) {
                        Navigator.pop(sheetContext);
                        otpController.clear();

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
                        setModalState(() {
                          bottomSheetError = otpState.error.isNotEmpty
                              ? otpState.error
                              : "Invalid OTP! Try again.";
                        });
                      }
                    },
                    builder: (ctx, otpState) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.viewInsetsOf(ctx).bottom,
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
                                    if (bottomSheetError != null) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        bottomSheetError!,
                                        style: TextStyle(
                                          color: colorScheme.error,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
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
                                          setModalState(() {
                                            bottomSheetError =
                                            "Please enter 4 digit OTP";
                                          });
                                          return;
                                        }

                                        setModalState(() {
                                          bottomSheetError = null;
                                        });

                                        ctx.read<OtpBloc>().add(
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
                                            isLogin: false,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Didn't receive code? ",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              bottomSheetError = null;
                                            });

                                            context.read<SignupBloc>().add(
                                              SendOtpRequested(
                                                mobileOrEmailID:
                                                otpVerifyType == "mobile"
                                                    ? mobileController
                                                    .text
                                                    .trim()
                                                    : emailController
                                                    .text
                                                    .trim(),
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Resending OTP..."),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Resend OTP",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
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
                  );
                },
              ),
            ),
          ).then((_) {
            setState(() {
              isOtpSheetOpen = false;
            });
          });
        }
      },
      builder: (context, state) {
        final bool isLoading = state is SignupLoading;

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
                        bottom: isKeyboardVisible
                            ? keyboardHeight + 5
                            : height * 0.04,
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
                                  title: isLoading ? "Submitting..." : "Submit →",
                                  onTap: isLoading
                                      ? () {}
                                      : () {
                                    if (!_formKey.currentState!
                                        .validate()) {
                                      return;
                                    }

                                    if (!isMobileVerified ||
                                        !isEmailVerified) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please verify both mobile number and email before submit",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    final fullName =
                                    fullNameController.text.trim();
                                    final emailText =
                                    emailController.text.trim();
                                    final mobileText =
                                    mobileController.text.trim();

                                    context.read<SignupBloc>().add(
                                      SignupSubmitted(
                                        businessName: widget.businessName,
                                        businessType: widget.businessType,
                                        gstNumber: widget.gstNumber,
                                        firstName: fullName,
                                        lastName: fullName,
                                        mobile: mobileText,
                                        email: emailText,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                              ],
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
      },
    );
  }
}