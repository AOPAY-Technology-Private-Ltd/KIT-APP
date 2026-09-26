import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../basic_detail/presentation/bloc/basic_details_bloc.dart';
import '../../../basic_detail/presentation/pages/basic_detail_step_screen.dart';
import '../bloc/create_loan_bloc.dart';
import '../bloc/create_loan_event.dart';
import '../bloc/create_loan_state.dart';
import '../widgets/step_progress_header.dart';
import '../widgets/upload_dashed_card.dart';

class DocumentsStepScreen extends StatefulWidget {
  const DocumentsStepScreen({super.key});

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

  // Format Validators (Optional but if filled, must be correct format)
  String? _validatePan(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(value.trim())) {
      return 'Enter valid PAN format (e.g. ABCDE1234F)';
    }
    return null;
  }

  String? _validateAadhaar(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional
    if (value.trim().length != 12) {
      return 'Aadhaar number must be 12 digits';
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
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
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
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        listener: (context, state) {
          if (state is PanVerifiedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PAN Verified Successfully!'), backgroundColor: Colors.blue),
            );
          } else if (state is AadhaarVerifiedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aadhaar Verified Successfully!'), backgroundColor: Colors.blue),
            );
          } else if (state is DocumentsSubmittedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Documents saved successfully! Next step...'), backgroundColor: Colors.green),
            );
          } else if (state is CreateLoanErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                          '1. Documents (Optional Fields Supported)',
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
                          decoration: _inputDecoration('DD/MM/YYYY').copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF2563EB), size: 20),
                              onPressed: () => _selectDate(context),
                            ),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Please select date of birth' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Pan Card (Optional)'),
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
                        _buildLabel('Aadhaar Card (Optional)'),
                        TextFormField(
                          controller: _aadhaarController,
                          keyboardType: TextInputType.number,
                          maxLength: 12,
                          decoration: _inputDecoration('Enter Aadhaar number').copyWith(counterText: ''),
                          validator: _validateAadhaar,
                          onChanged: (val) {
                            // Jaise hi user 12 digits pure bharega, API se verify hoga
                            if (val.trim().length == 12) {
                              BlocProvider.of<CreateLoanBloc>(context).add(VerifyAadhaarEvent(val.trim()));
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
                                  _buildLabel('Back Image'),
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
                          // 1. Pehle documents submit event bhej dein
                          BlocProvider.of<CreateLoanBloc>(context).add(
                            SubmitDocumentsEvent(
                              dob: _dobController.text,
                              panNumber: _panController.text.isNotEmpty ? _panController.text : null,
                              panPhoto: _panPhotoFile,
                              aadhaarNumber: _aadhaarController.text.isNotEmpty ? _aadhaarController.text : null,
                              frontImage: _frontImageFile,
                              backImage: _backImageFile,
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (_) => sl<BasicDetailsBloc>(),
                                child: const BasicDetailStepScreen(),
                              ),
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

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 48,
      padding: const EdgeInsets.only(top: 5, left: 16, right: 5, bottom: 5),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 0.50),
          end: Alignment(0.00, 0.50),
          colors: [Color(0xFF022062), Color(0xFF008EFD)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}