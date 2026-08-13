import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/routes/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/common/widgets/auth_button.dart';
import '../widgets/image_preview_dialog.dart';
import '../widgets/custom_header.dart';
import '../widgets/customer_text_field.dart';
import '../widgets/upload_box.dart';
import 'package:go_router/go_router.dart';

class CreateCustomerView extends StatefulWidget {
  const CreateCustomerView({super.key});

  @override
  State<CreateCustomerView> createState() => _CreateCustomerViewState();
}

class _CreateCustomerViewState extends State<CreateCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final dobController = TextEditingController();
  final panController = TextEditingController();
  final aadharController = TextEditingController();

  File? panImage;
  File? aadharFrontImage;
  File? aadharBackImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String docType) async {
    File? currentImage;
    if (docType == 'pan') currentImage = panImage;
    if (docType == 'front') currentImage = aadharFrontImage;
    if (docType == 'back') currentImage = aadharBackImage;

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
                if (currentImage != null)
                  InkWell(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      ImagePreviewDialog.show(context, currentImage!);
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.visibility, color: Color(0xFF2563EB)),
                          SizedBox(width: 16),
                          Text(
                            'Preview Image',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        if (docType == 'pan') panImage = File(image.path);
                        if (docType == 'front') aadharFrontImage = File(image.path);
                        if (docType == 'back') aadharBackImage = File(image.path);
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Color(0xFF2563EB)),
                        SizedBox(width: 16),
                        Text(
                          'Take Photo from Camera',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
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
                        if (docType == 'pan') panImage = File(image.path);
                        if (docType == 'front') aadharFrontImage = File(image.path);
                        if (docType == 'back') aadharBackImage = File(image.path);
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Color(0xFF2563EB)),
                        SizedBox(width: 16),
                        Text(
                          'Choose from Gallery',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
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

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    dobController.dispose();
    panController.dispose();
    aadharController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: CustomHeader(
                title: 'Create Customer',
                showSearch: false,
                showNotification: false,
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      CustomerTextField(
                        controller: dobController,
                        label: 'Date of Birth (Optional)',
                        hintText: 'DD/MM/YYYY',
                        readOnly: true,
                        onTap: () => _selectDateOfBirth(context),
                        suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF2563EB), size: 18),
                      ),
                      const SizedBox(height: 16),

                      CustomerTextField(
                        controller: panController,
                        label: 'Pan Card (Optional)',
                        hintText: 'Enter PAN number (e.g. ABCDE1234F)',
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          TextInputFormatter.withFunction((oldValue, newValue) => newValue.copyWith(text: newValue.text.toUpperCase())),
                        ],
                        validator: Validators.validatePan,
                      ),
                      const SizedBox(height: 12),

                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: UploadBox(
                            label: panImage == null ? 'Upload PAN' : 'PAN Uploaded ✓',
                            selectedImage: panImage,
                            onTap: () => _pickImage('pan'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomerTextField(
                        controller: aadharController,
                        label: 'Aadhaar Card (Optional)',
                        hintText: 'Enter 12-digit number',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: Validators.validateAadhaar,
                      ),
                      const SizedBox(height: 12),

                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 90,
                                  child: UploadBox(
                                    label: aadharFrontImage == null ? 'Front Image' : 'Front Uploaded ✓',
                                    selectedImage: aadharFrontImage,
                                    onTap: () => _pickImage('front'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 90,
                                  child: UploadBox(
                                    label: aadharBackImage == null ? 'Back Image' : 'Back Uploaded ✓',
                                    selectedImage: aadharBackImage,
                                    onTap: () => _pickImage('back'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).viewInsets.bottom > 0
              ? MediaQuery.of(context).viewInsets.bottom + 12
              : MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: AuthButton(
          title: 'Next',
          onTap: () {
            if (_formKey.currentState!.validate()) {
              context.push(
                RouteNames.customerInfo,
                extra: {
                  'dob': dobController.text.trim(),
                  'panNumber': panController.text.trim(),
                  'panImage': panImage,
                  'aadharNumber': aadharController.text.trim(),
                  'aadharFrontImage': aadharFrontImage,
                  'aadharBackImage': aadharBackImage,
                },
              );
            }
          },
        ),
      ),
    );
  }
}