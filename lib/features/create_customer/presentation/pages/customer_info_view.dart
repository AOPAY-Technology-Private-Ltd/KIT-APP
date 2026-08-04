import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/routes/route_names.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/custom_header.dart';
import '../widgets/customer_text_field.dart';

class CustomerInfoView extends StatelessWidget {
  const CustomerInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerBloc>(
      create: (context) => CustomerBloc(
        verifyCustomerUseCase: sl(),
        manageCustomerUseCase: sl(),
      ),
      child: const _CustomerInfoViewContent(),
    );
  }
}

class _CustomerInfoViewContent extends StatefulWidget {
  const _CustomerInfoViewContent();

  @override
  State<_CustomerInfoViewContent> createState() => _CustomerInfoViewState();
}

class _CustomerInfoViewState extends State<_CustomerInfoViewContent> {
  bool isChecked = false;
  bool isMobileVerifiedOrAvailable = true;
  String? mobileErrorText;

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final altMobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    mobileController.addListener(_onMobileNumberChanged);
  }

  void _onMobileNumberChanged() {
    final text = mobileController.text.trim();
    if (text.length == 10) {
      context.read<CustomerBloc>().add(KitVerifyRequested(primaryMobileNumber: text));
    } else {
      if (!isMobileVerifiedOrAvailable) {
        setState(() {
          isMobileVerifiedOrAvailable = true;
          mobileErrorText = null;
        });
      }
    }
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        profileImage = File(image.path);
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Color(0xFF2563EB)),
                        SizedBox(width: 16),
                        Text('Take Photo from Camera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        profileImage = File(image.path);
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Color(0xFF2563EB)),
                        SizedBox(width: 16),
                        Text('Choose from Gallery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
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
  void dispose() {
    mobileController.removeListener(_onMobileNumberChanged);
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    altMobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? previousData = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerSuccess) {
            if (state.message.contains("already exists") || state.message.toLowerCase().contains("exists")) {
              setState(() {
                isMobileVerifiedOrAvailable = false;
                mobileErrorText = state.message;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              setState(() {
                isMobileVerifiedOrAvailable = true;
                mobileErrorText = null;
              });
            }
          } else if (state is CustomerFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          bool isVerifying = state is CustomerLoading;

          return SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CustomHeader(title: 'Customer Info'),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: profileImage != null
                                      ? Image.file(
                                    profileImage!,
                                    width: size.width * 0.22,
                                    height: size.width * 0.22,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.asset(
                                    'assets/images/profile.png',
                                    width: size.width * 0.22,
                                    height: size.width * 0.22,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickProfileImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2563EB),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomerTextField(
                                  controller: firstNameController,
                                  label: 'First Name *',
                                  hintText: 'Enter First Name',
                                  validator: (val) => val == null || val.trim().isEmpty ? "First Name is required" : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomerTextField(
                                  controller: lastNameController,
                                  label: 'Last Name *',
                                  hintText: 'Enter Last Name',
                                  validator: (val) => val == null || val.trim().isEmpty ? "Last Name is required" : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomerTextField(
                                  controller: mobileController,
                                  label: 'Mobile Number *',
                                  hintText: 'Enter Mobile Number',
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                  suffixIcon: isVerifying
                                      ? const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                      : (!isMobileVerifiedOrAvailable
                                      ? const Icon(Icons.error, color: Colors.red, size: 20)
                                      : null),
                                  validator: (val) {
                                    String? basicVal = Validators.validateMobile(val ?? '');
                                    if (basicVal != null) return basicVal;
                                    if (!isMobileVerifiedOrAvailable) {
                                      return mobileErrorText ?? "Mobile number already exists";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomerTextField(
                                  controller: altMobileController,
                                  label: 'Alternate Number (Optional)',
                                  hintText: 'Enter Alternate Number',
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          CustomerTextField(
                            controller: emailController,
                            label: 'Email ID (Optional)',
                            hintText: 'Enter e-mail',
                            validator: (val) {
                              if (val != null && val.trim().isEmpty) return null;
                              return Validators.validateEmail(val ?? '');
                            },
                          ),
                          const SizedBox(height: 16),

                          CustomerTextField(
                            controller: addressController,
                            label: 'Address (Optional)',
                            hintText: 'Enter Address',
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                  value: isChecked,
                                  onChanged: (val) {
                                    setState(() {
                                      isChecked = val ?? false;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Accept Terms and Condition',
                                style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: Container(
                              decoration: ShapeDecoration(
                                gradient: (isChecked && isMobileVerifiedOrAvailable)
                                    ? const LinearGradient(
                                  begin: Alignment(1.00, 0.50),
                                  end: Alignment(0.00, 0.50),
                                  colors: [Color(0xFF022062), Color(0xFF008EFD)],
                                )
                                    : null,
                                color: (isChecked && isMobileVerifiedOrAvailable) ? null : Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: (isChecked && isMobileVerifiedOrAvailable)
                                    ? () {
                                  if (_formKey.currentState!.validate()) {
                                    context.push(
                                      RouteNames.imeiNumber,
                                      extra: {
                                        'dob': previousData?['dob'],
                                        'panNumber': previousData?['panNumber'],
                                        'panImage': previousData?['panImage'],
                                        'aadharNumber': previousData?['aadharNumber'],
                                        'aadharFrontImage': previousData?['aadharFrontImage'],
                                        'aadharBackImage': previousData?['aadharBackImage'],
                                        'firstName': firstNameController.text.trim(),
                                        'lastName': lastNameController.text.trim(),
                                        'primaryMobileNumber': mobileController.text.trim(),
                                        'alternateMobileNumber': altMobileController.text.trim(),
                                        'emailID': emailController.text.trim(),
                                        'currentAddress': addressController.text.trim(),
                                        'profileImage': profileImage,
                                      },
                                    );
                                  }
                                }
                                    : null,
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: (isChecked && isMobileVerifiedOrAvailable) ? Colors.white : Colors.grey.shade600,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
    );
  }
}