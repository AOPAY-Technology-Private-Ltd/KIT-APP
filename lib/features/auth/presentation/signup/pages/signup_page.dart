import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logkit/features/auth/presentation/signup/pages/personal_details_page.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../../common/widgets/auth_logo.dart';
import '../../common/widgets/auth_image_slider.dart';
import '../../common/widgets/curved_top_container.dart';
import '../../common/widgets/auth_footer.dart';
import '../../common/widgets/auth_button.dart';

import '../../verifyotp/pages/otp_verification_view.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_state.dart';

import '../widgets/already_login_link.dart';
import '../widgets/signup_text_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessTypeController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();

  final List<String> businessTypes = [
    'Mobile',
    'Electronics',
  ];

  @override
  void dispose() {
    businessNameController.dispose();
    businessTypeController.dispose();
    gstNumberController.dispose();
    super.dispose();
  }

  void _showSelectionBottomSheet({
    required String title,
    required List<String> items,
    required TextEditingController controller,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 8),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = controller.text == item;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            controller.text = item;
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  size: 22,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: colorScheme.error,
              ),
            );
          } else if (state is SignupSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<SignupBloc>(),
                  child: const OtpVerificationView(
                    mobile: "9999179728",
                  ),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final bool isKeyboardVisible = keyboardHeight > 0;
              final double imageSize = isKeyboardVisible ? 90.0 : 200.0;

              return Container(
                width: double.infinity,
                height: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(gradient: AppTheme.loginGradient),
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
                        child: AuthImageSlider(size: imageSize),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      left: -width * 0.42,
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
                              Text("Onboarding", style: theme.textTheme.headlineSmall),
                              SizedBox(height: height * 0.008),
                              const Text(
                                "Business Details",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: height * 0.008),
                              SignupTextField(
                                label: "Business Name",
                                hint: "Enter Business Name",
                                requiredField: true,
                                controller: businessNameController,
                                validator: (val) {
                                  val = val?.trim() ?? "";
                                  if (val.isEmpty) return "Field is mandatory!";
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.008),
                              SignupTextField(
                                label: "Business Type",
                                hint: "--Select Business Type--",
                                requiredField: true,
                                controller: businessTypeController,
                                readOnly: true,
                                onTap: () {
                                  _showSelectionBottomSheet(
                                    title: "Select Business Type",
                                    items: businessTypes,
                                    controller: businessTypeController,
                                  );
                                },
                                validator: (val) {
                                  val = val?.trim() ?? "";
                                  if (val.isEmpty) return "Business Type is required!";
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.008),
                              SignupTextField(
                                label: "GST Number (Optional)",
                                hint: "Enter GST Number (Optional)",
                                requiredField: false,
                                controller: gstNumberController,
                                validator: (val) {
                                  val = val?.trim() ?? "";
                                  if (val.isEmpty) return null;
                                  final gstRegExp = RegExp(
                                    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                                  );
                                  if (!gstRegExp.hasMatch(val)) {
                                    return "Please enter a valid 15-digit GST number";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.015),
                              AuthButton(
                                title: "Next →",
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<SignupBloc>(),
                                          child: PersonalDetailsView(
                                            businessName: businessNameController.text.trim(),
                                            businessType: businessTypeController.text.trim(),
                                            gstNumber: gstNumberController.text.trim(),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: height * 0.008),
                              AlreadyLoginLink(
                                onTap: () {
                                  Navigator.pop(context);
                                },
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