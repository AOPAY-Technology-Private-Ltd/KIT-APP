import 'dart:io';
import 'package:flutter/material.dart';
import 'image_upload_card.dart';

class ImeiFormSection extends StatelessWidget {
  final TextEditingController imei1Controller;
  final TextEditingController imei2Controller;
  final File? sealFront;
  final File? sealBack;
  final File? imeiPhoto;
  final File? invoicePhoto;
  final Function(File, String) onImageChanged;

  const ImeiFormSection({
    super.key,
    required this.imei1Controller,
    required this.imei2Controller,
    this.sealFront,
    this.sealBack,
    this.imeiPhoto,
    this.invoicePhoto,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'IMEI 1*',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: imei1Controller,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "IMEI 1 is required";
            }
            if (val.trim().length < 15) {
              return "Please enter a valid IMEI number";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter IMEI 1',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'IMEI 2*',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: imei2Controller,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "IMEI 2 is required";
            }
            if (val.trim().length < 15) {
              return "Please enter a valid IMEI number";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter IMEI 2',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ImageUploadCard(
                label: 'Seal Phone Front (Optional)',
                selectedImage: sealFront,
                onImageSelected: (file) => onImageChanged(file, 'sealFront'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ImageUploadCard(
                label: 'Seal Phone Back (Optional)',
                selectedImage: sealBack,
                onImageSelected: (file) => onImageChanged(file, 'sealBack'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ImageUploadCard(
                label: 'IMEI Number (Optional)',
                selectedImage: imeiPhoto,
                onImageSelected: (file) => onImageChanged(file, 'imeiPhoto'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ImageUploadCard(
                label: 'Invoice (Optional)',
                selectedImage: invoicePhoto,
                onImageSelected: (file) => onImageChanged(file, 'invoicePhoto'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}