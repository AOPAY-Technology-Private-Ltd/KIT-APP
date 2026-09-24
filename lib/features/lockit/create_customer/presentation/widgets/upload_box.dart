import 'dart:io';
import 'package:flutter/material.dart';

class UploadBox extends StatelessWidget {
  final String label;
  final File? selectedImage;
  final VoidCallback onTap;

  const UploadBox({
    Key? key,
    required this.label,
    required this.selectedImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedImage != null ? const Color(0xFF2563EB) :  Colors.black.withValues(alpha: 0.40),

            width: selectedImage != null ? 1.0 : 1,
          ),
        ),
        child: selectedImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined, color: Color(0xFF2563EB), size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}