import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logkit/features/loan/loan_flow/basic_detail/presentation/pages/terms_and_conditions_screen.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';
import '../bloc/basic_details_bloc.dart';
import '../bloc/basic_details_event.dart';
import '../bloc/basic_details_state.dart';
import '../widgets/customer_photo_section.dart';


class BasicDetailStepScreen extends StatefulWidget {
  const BasicDetailStepScreen({super.key});

  @override
  State<BasicDetailStepScreen> createState() => _BasicDetailStepScreenState();
}

class _BasicDetailStepScreenState extends State<BasicDetailStepScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alternateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _customerPhotoFile;
  bool _acceptTerms = false;

  Future<void> _pickCustomerPhotoFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _customerPhotoFile = File(image.path);
      });
    }
  }

  void _showOtpVerificationDialog(BuildContext context, String mobileNumber) {
    if (mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number first'), backgroundColor: Colors.red),
      );
      return;
    }

    final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lock_outline, color: Color(0xFF022062), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Verify OTP',
                          style: TextStyle(
                            color: Color(0xFF022062),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'We sent a 4-digit verification code to\n$mobileNumber',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      height: 52,
                      child: TextFormField(
                        controller: otpControllers[index],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Resend in 00:45',
                      style: TextStyle(color: Colors.grey, fontSize: 11, fontFamily: 'Inter'),
                    ),
                    Text(
                      'Resend Code',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CustomGradientButton(
                    text: 'Verify & Proceed',
                    isLoading: false,
                    onPressed: () {
                      String enteredOtp = otpControllers.map((c) => c.text.trim()).join();
                      if (enteredOtp.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid 4-digit OTP'), backgroundColor: Colors.red),
                        );
                        return;
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mobile number verified successfully!'), backgroundColor: Colors.green),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF022062),
        elevation: 0,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CustomHeaderIconButton(
              child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF022062), size: 12),
              onTap: () => Navigator.pop(context),
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
              child: CustomHeaderIconButton(
                child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF022062), size: 12),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.documentsStep);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BasicDetailsBloc, BasicDetailsState>(
        listener: (context, state) {
          if (state is BasicDetailsSubmittedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Basic details saved successfully!'), backgroundColor: Colors.green),
            );
          } else if (state is BasicDetailsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const StepProgressHeader(currentStep: 2),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2. Basic Detail',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        CustomerPhotoSection(
                          customerPhotoFile: _customerPhotoFile,
                          onPickPhoto: _pickCustomerPhotoFromCamera,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('First Name*'),
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: _inputDecoration('Enter First Name'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter First Name' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Last Name*'),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: _inputDecoration('Enter Last Name'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter Last Name' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Mobile Number*'),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: _inputDecoration('Enter Mobile Number').copyWith(counterText: ''),
                          validator: (val) {
                            if (val == null || val.trim().length != 10) return 'Enter valid 10-digit mobile number';
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _showOtpVerificationDialog(context, _mobileController.text.trim());
                            },
                            child: const Text('Verify', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),

                        _buildLabel('Alternate Number (Optional)'),
                        TextFormField(
                          controller: _alternateController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: _inputDecoration('Enter Alternate Number').copyWith(counterText: ''),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Email ID (Optional)'),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration('Enter Email ID'),
                          validator: (val) {
                            if (val != null && val.trim().isNotEmpty && !val.contains('@')) {
                              return 'Enter valid email ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Address (Optional)'),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 3,
                          decoration: _inputDecoration('Enter Address'),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              activeColor: const Color(0xFF022062),
                              onChanged: (val) {
                                setState(() {
                                  _acceptTerms = val ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TermsAndConditionsScreen(),
                                    ),
                                  );


                                },
                                child: const Text(
                                  'Accept Terms and Condition',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
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
                    child: CustomGradientButton(
                      text: 'Next',
                      isLoading: state is BasicDetailsLoadingState,
                      onPressed: () {
                        if (_customerPhotoFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please capture customer photo'), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        if (!_acceptTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please accept terms and condition'), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<BasicDetailsBloc>(context).add(
                            SubmitBasicDetailsEvent(
                              customerPhoto: _customerPhotoFile,
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              mobileNumber: _mobileController.text.trim(),
                              alternateNumber: _alternateController.text.trim().isNotEmpty ? _alternateController.text.trim() : null,
                              emailId: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
                              address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
                              acceptTerms: _acceptTerms,
                            ),
                          );

                          context.go(RouteNames.loanDetailStep);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.30),
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.black.withValues(alpha: 0.40),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.black.withValues(alpha: 0.40),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF2563EB),
        ),
      ),
    );
  }
}