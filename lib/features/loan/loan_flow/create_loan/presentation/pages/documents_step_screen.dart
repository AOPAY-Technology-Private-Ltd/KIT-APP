import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../bloc/create_loan_bloc.dart';
import '../bloc/create_loan_event.dart';
import '../bloc/create_loan_state.dart';
import '../widgets/step_progress_header.dart';
import '../widgets/upload_dashed_card.dart';
import 'aadhaar_webview_screen.dart';

class DocumentsStepScreen extends StatefulWidget {
  final String firstName;
  final String? lastName;
  final String? mobileNumber;
  final String otp;
  final String? emailId;
  final String? address;
  final String? pinCode;
  final String? stateName;
  final String? cityName;

  const DocumentsStepScreen({
    super.key,
    required this.firstName,
    this.lastName,
    this.mobileNumber,
    required this.otp,
    this.emailId,
    this.address,
    this.pinCode,
    this.stateName,
    this.cityName,
  });

  @override
  State<DocumentsStepScreen> createState() => _DocumentsStepScreenState();
}

class _DocumentsStepScreenState extends State<DocumentsStepScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();

  File? _panPhotoFile;
  File? _frontImageFile;
  File? _backImageFile;

  bool get _hasAnyCoreFieldFilled {
    return _dobController.text.trim().isNotEmpty ||
        _panController.text.trim().isNotEmpty ||
        _aadhaarController.text.trim().isNotEmpty;
  }

  String? _validateDob(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (_hasAnyCoreFieldFilled) {
        return 'Please select Date of Birth';
      }
    }
    return null;
  }

  String? _validatePan(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (_hasAnyCoreFieldFilled) {
        return 'Please enter PAN number';
      }
      return null;
    }
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(value.trim())) {
      return 'Enter valid PAN format (e.g. ABCDE1234F)';
    }
    return null;
  }

  String? _validateAadhaar(String? value) {
    if (value == null || value.trim().isEmpty) {
      if (_hasAnyCoreFieldFilled) {
        return 'Please enter Aadhaar Card number';
      }
      return null;
    }
    if (value.trim().length != 12) {
      return 'Number must be 12 digits';
    }
    return null;
  }

  Future<void> _pickImage(String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image != null) {
      setState(() {
        if (type == 'pan') {
          _panPhotoFile = File(image.path);
        } else if (type == 'front') {
          _frontImageFile = File(image.path);
        } else if (type == 'back') {
          _backImageFile = File(image.path);
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF022062),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final DateTime today = DateTime.now();
      DateTime adultDate = DateTime(
        picked.year + 18,
        picked.month,
        picked.day,
      );

      if (adultDate.isAfter(today)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User must be at least 18 years old.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        setState(() {
          _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.basicDetailsStep);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF022062),
          elevation: 0,
          leading: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CustomHeaderIconButton(
                child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF022062), size: 12),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.basicDetailsStep);
                  }
                },
              ),
            ),
          ),
          title: const Text(
            'Add Customer',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
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
        body: BlocConsumer<CreateLoanBloc, CreateLoanState>(
          listener: (context, state) async {
            if (state is PanVerifiedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PAN Verified Successfully!'),
                  backgroundColor: Colors.blue,
                ),
              );
            } else if (state is AadhaarVerificationUrlReceivedState) {
              final bool? isVerified = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AadhaarWebViewScreen(
                    kycUrl: state.kycUrl,
                    transactionId: state.transactionId,
                  ),
                ),
              );

              if (isVerified == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('KYC Completed Successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else if (state is DocumentsSubmittedSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Credit Report fetched & details saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.push(RouteNames.loanDetailStep);
            } else if (state is CreateLoanErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const StepProgressHeader(currentStep: 1),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '1. Documents & Credit Report',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF022062),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabel('Date of Birth'),
                          TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: _validateDob,
                            decoration: _inputDecoration('YYYY-MM-DD').copyWith(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF2563EB), size: 20),
                                onPressed: () => _selectDate(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabel('Pan Card'),
                          TextFormField(
                            controller: _panController,
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 10,
                            decoration: _inputDecoration('Enter PAN number').copyWith(counterText: ''),
                            validator: _validatePan,
                            onChanged: (val) {
                              if (val.trim().length == 10) {
                                BlocProvider.of<CreateLoanBloc>(context).add(VerifyPanEvent(val.trim()));
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildLabel('PAN Card Photo'),
                          UploadDashedCard(
                            file: _panPhotoFile,
                            onTap: () => _pickImage('pan'),
                            title: 'PAN Card Photo',
                          ),
                          const SizedBox(height: 16),
                          _buildLabel('Aadhaar Card'),
                          TextFormField(
                            controller: _aadhaarController,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                            decoration: _inputDecoration('Enter Aadhaar Card number').copyWith(counterText: ''),
                            validator: _validateAadhaar,
                            onChanged: (val) {
                              if (val.trim().length == 12) {
                                BlocProvider.of<CreateLoanBloc>(context).add(
                                  VerifyAadhaarEvent(
                                    val.trim(),
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    mobileNumber: widget.mobileNumber,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Front Image'),
                                    UploadDashedCard(
                                      file: _frontImageFile,
                                      onTap: () => _pickImage('front'),
                                      title: 'Front Image',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Field Back Image'),
                                    UploadDashedCard(
                                      file: _backImageFile,
                                      onTap: () => _pickImage('back'),
                                      title: 'Back Image',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
                        isLoading: state is CreateLoanLoadingState,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final finalPan = _panController.text.trim().isNotEmpty
                                ? _panController.text.trim()
                                : 'ABCDE1234F';

                            final finalAadhaar = _aadhaarController.text.trim();

                            debugPrint('=== Dispatching GetCreditReportEvent with OTP: ${widget.otp} ===');

                            debugPrint('=== Dispatching GetCreditReportEvent with address: ${widget.address} ===');


                            BlocProvider.of<CreateLoanBloc>(context).add(
                              GetCreditReportEvent(
                                firstName: widget.firstName,
                                lastName: widget.lastName ?? '',
                                mobileNumber: widget.mobileNumber ?? '',
                                dateOfBirth: _dobController.text.trim().isNotEmpty
                                    ? _dobController.text.trim()
                                    : '1995-01-01',
                                emailId: widget.emailId?.isNotEmpty == true
                                    ? widget.emailId!
                                    : 'testuser@gmail.com',
                                panNumber: finalPan,
                                aadhaarNumber: finalAadhaar,
                                otp: widget.otp,
                                consentMessage: 'I agree to fetch credit report',
                                consentAcceptance: 'yes',
                                address: widget.address,
                                pinCode: null,
                                stateName: null,
                                cityName: null,

                                customerPhoto: null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB))),
    );
  }
}