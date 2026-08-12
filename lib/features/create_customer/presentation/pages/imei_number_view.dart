import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes/route_names.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';
import '../widgets/imei_form_section.dart';

class ImeiNumberView extends StatefulWidget {
  const ImeiNumberView({super.key});

  @override
  State<ImeiNumberView> createState() => _ImeiNumberViewState();
}

class _ImeiNumberViewState extends State<ImeiNumberView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _imei1Controller = TextEditingController();
  final TextEditingController _imei2Controller = TextEditingController();

  File? _sealFront;
  File? _sealBack;
  File? _imeiPhoto;
  File? _invoicePhoto;

  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void initState() {
    super.initState();
    _imei1Controller.addListener(_onImeiChanged);
    _imei2Controller.addListener(_onImeiChanged);
  }

  void _onImeiChanged() {
    _handleControllerValidation(_imei1Controller);
    _handleControllerValidation(_imei2Controller);
    setState(() {});
  }

  void _handleControllerValidation(TextEditingController controller) {
    String text = controller.text;
    String filtered = text.replaceAll(RegExp(r'\D'), '');
    if (filtered.length > 15) {
      filtered = filtered.substring(0, 15);
    }
    if (filtered != text) {
      controller.value = TextEditingValue(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }
  }

  @override
  void dispose() {
    _imei1Controller.removeListener(_onImeiChanged);
    _imei2Controller.removeListener(_onImeiChanged);
    _imei1Controller.dispose();
    _imei2Controller.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  bool get _isFormValid {
    return _imei1Controller.text.trim().length == 15 &&
        _imei2Controller.text.trim().length == 15;
  }

  Future<void> _pickImageFor(String type) async {
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
                      imageQuality: 85,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        _updateImageFile(type, File(image.path));
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
                      imageQuality: 85,
                    );
                    if (image != null && mounted) {
                      setState(() {
                        _updateImageFile(type, File(image.path));
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

  void _updateImageFile(String type, File file) {
    setState(() {
      if (type == 'sealFront') _sealFront = file;
      if (type == 'sealBack') _sealBack = file;
      if (type == 'imeiPhoto') _imeiPhoto = file;
      if (type == 'invoicePhoto') _invoicePhoto = file;
    });
  }

  Future<void> _captureAndExtractImei() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image == null) return;

    setState(() {
      _isProcessing = true;
    });

    File capturedFile = File(image.path);

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      List<String> foundImeis = [];
      final RegExp imeiRegExp = RegExp(r'\b\d{15}\b');

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final matches = imeiRegExp.allMatches(line.text);
          for (final match in matches) {
            final imei = match.group(0);
            if (imei != null && !foundImeis.contains(imei)) {
              foundImeis.add(imei);
            }
          }
        }
      }

      if (foundImeis.isEmpty) {
        for (int i = 0; i < recognizedText.blocks.length; i++) {
          String blockText = recognizedText.blocks[i].text.replaceAll(RegExp(r'\s+'), '');
          final numbers = RegExp(r'\d{14,16}').allMatches(blockText);
          for (var numMatch in numbers) {
            String val = numMatch.group(0)!;
            if (val.length == 15 && !foundImeis.contains(val)) {
              foundImeis.add(val);
            }
          }
        }
      }

      setState(() {
        if (foundImeis.isNotEmpty) {
          _imei1Controller.text = foundImeis[0];
          if (foundImeis.length > 1) {
            _imei2Controller.text = foundImeis[1];
          }
        }
        _imeiPhoto = capturedFile;
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(foundImeis.isNotEmpty
                ? 'IMEI numbers extracted successfully!'
                : 'Sticker scanned successfully, but IMEI could not be detected. Please try again.'),
            backgroundColor: foundImeis.isNotEmpty ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _imeiPhoto = capturedFile;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showFullImageView(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: Image.file(imageFile),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? customerData = GoRouterState.of(context).extra as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2563EB), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'IMEI Number',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const CircleAvatar(
        //       radius: 16,
        //       backgroundColor: Color(0xFF2563EB),
        //       child: Icon(Icons.notifications_none, color: Colors.white, size: 16),
        //     ),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: const CircleAvatar(
        //       radius: 16,
        //       backgroundColor: Color(0xFF2563EB),
        //       child: Icon(Icons.search, color: Colors.white, size: 16),
        //     ),
        //     onPressed: () {},
        //   ),
        //   const SizedBox(width: 8),
        // ],
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );

            context.go(RouteNames.home, extra: {'initialIndex': 1});

          } else if (state is CustomerFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is CustomerLoading;

          return SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEFF6FF),
                                foregroundColor: const Color(0xFF2563EB),
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isProcessing ? null : _captureAndExtractImei,
                              icon: const Icon(Icons.camera_alt, size: 20),
                              label: Text(
                                _imeiPhoto == null ? 'Capture Box Sticker (Optional)' : 'Box Sticker Captured ✓',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _imeiPhoto == null ? const Color(0xFF2563EB) : Colors.green.shade700,
                                ),
                              ),
                            ),
                          ),
                          if (_imeiPhoto != null) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _showFullImageView(_imeiPhoto!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _imeiPhoto!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: ImeiFormSection(
                            imei1Controller: _imei1Controller,
                            imei2Controller: _imei2Controller,
                            sealFront: _sealFront,
                            sealBack: _sealBack,
                            imeiPhoto: _imeiPhoto,
                            invoicePhoto: _invoicePhoto,
                            onImageChanged: (file, type) {
                              if (file != null) {
                                _updateImageFile(type, file);
                              } else {
                                _pickImageFor(type);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Container(
                          decoration: ShapeDecoration(
                            gradient: _isFormValid
                                ? const LinearGradient(
                              begin: Alignment(1.00, 0.50),
                              end: Alignment(0.00, 0.50),
                              colors: [Color(0xFF022062), Color(0xFF008EFD)],
                            )
                                : null,
                            color: _isFormValid ? null : Colors.grey.shade300,
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
                            onPressed: _isFormValid && !isLoading
                                ? () {
                              if (_formKey.currentState!.validate()) {
                                final data = customerData ?? {};

                                context.read<CustomerBloc>().add(
                                  ManageCustomerSubmitted(
                                    firstName: data['firstName'] ?? '',
                                    lastName: data['lastName'] ?? '',
                                    primaryMobileNumber: data['primaryMobileNumber'] ?? '',
                                    alternateMobileNumber: data['alternateMobileNumber'],
                                    emailID: data['emailID'],
                                    currentAddress: data['currentAddress'],
                                    profileImage: data['profileImage'],
                                    panNumber: data['panNumber'],
                                    panImage: data['panImage'],
                                    aadharNumber: data['aadharNumber'],
                                    aadharFrontImage: data['aadharFrontImage'],
                                    aadharBackImage: data['aadharBackImage'],
                                    imeiNumber1: _imei1Controller.text.trim(),
                                    imeiNumber2: _imei2Controller.text.trim(),
                                    imeiNumberPhotoFile: _imeiPhoto,
                                    imeiNumber1SealPhotoFile: _sealFront,
                                    imeiNumber2SealPhotoFile: _sealBack,
                                    invoiceFile: _invoicePhoto,
                                  ),
                                );
                              }
                            }
                                : null,
                            child: isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : Text(
                              'Next',
                              style: TextStyle(
                                color: _isFormValid ? Colors.white : Colors.grey.shade600,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isProcessing || isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2563EB),
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