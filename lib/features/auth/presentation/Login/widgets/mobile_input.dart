import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileInput extends StatefulWidget {
  final TextEditingController controller;
  const MobileInput({super.key, required this.controller});

  @override
  State<MobileInput> createState() => _MobileInputState();
}

class _MobileInputState extends State<MobileInput> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isEmailMode = widget.controller.text.contains('@');

    final bool isNumericMode = !isEmailMode && RegExp(r'^[0-9]*$').hasMatch(widget.controller.text);

    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 8,
              offset: const Offset(0, 3)
          )
        ],
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        onChanged: (val) => setState(() {}),

        inputFormatters: isEmailMode ? [] : [LengthLimitingTextInputFormatter(10)],

        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefix: (isNumericMode && widget.controller.text.isNotEmpty)
              ? const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text("+91 ", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
          )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(.5),
          hintText: "Enter mobile number or Email",
          hintStyle: theme.textTheme.labelMedium,
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: 17
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.6), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.6), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
          ),
        ),
      ),
    );
  }
}