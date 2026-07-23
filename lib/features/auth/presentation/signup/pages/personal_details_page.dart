import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/utils/validators.dart';

import '../../common/widgets/auth_button.dart';
import '../../common/widgets/auth_footer.dart';
import '../../common/widgets/auth_logo.dart';
import '../../common/widgets/auth_image_slider.dart';
import '../../common/widgets/curved_top_container.dart';

import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../widgets/already_login_link.dart';
import '../widgets/signup_text_field.dart';

class PersonalDetailsView extends StatefulWidget {
  final String businessName;
  final String businessType;
  final String? gstType;

  const PersonalDetailsView({
    super.key,
    required this.businessName,
    required this.businessType,
    this.gstType,
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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final bool isKeyboardVisible = keyboardHeight > 0;
          final double imageSize = isKeyboardVisible ? 110.0 : 200.0;

          return Container(
            decoration: BoxDecoration(
              gradient: AppTheme.loginGradient,
            ),
            child: Stack(
              children: [
                if (!isKeyboardVisible)
                  Positioned(
                    top: height * .05,
                    left: 0,
                    right: 0,
                    child: const AuthLogo(),
                  ),

                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  top: isKeyboardVisible ? height * .02 : height * .16,
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
                  bottom: isKeyboardVisible ? keyboardHeight - 20 : -10,
                  child: SizedBox(
                    width: width * 1.84,
                    height: height * 0.63,
                    child: const CurvedTopContainer(
                      curveHeight: .34,
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
                            height: height * 0.010,
                          ),
                          Text(
                            "Personal Details",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 18),
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
                          const SizedBox(height: 12),
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
                          const SizedBox(height: 12),
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
                          const SizedBox(height: 22),
                          AuthButton(
                            title: "Submit →",
                            onTap: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              context.read<SignupBloc>().add(
                                SignupSubmitted(
                                  businessName: widget.businessName,
                                  businessType: widget.businessType,
                                  gstType: widget.gstType,
                                  fullName: fullNameController.text.trim(),
                                  mobile: mobileController.text.trim(),
                                  email: emailController.text.trim(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
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
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: AuthFooter(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}