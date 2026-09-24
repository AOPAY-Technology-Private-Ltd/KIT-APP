import 'package:flutter/material.dart';

class DeviceSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const DeviceSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withValues(alpha: 0.70),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Mobile, Model Name',
            hintStyle: TextStyle(
              color: Colors.black.withValues(alpha: 0.40),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 20, right: 12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black.withValues(alpha: 0.50),
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 11),
          ),
        ),
      ),
    );
  }
}