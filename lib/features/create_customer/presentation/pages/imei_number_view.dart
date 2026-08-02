import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/customer_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _imei1Controller.addListener(_updateState);
    _imei2Controller.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _imei1Controller.removeListener(_updateState);
    _imei2Controller.removeListener(_updateState);
    _imei1Controller.dispose();
    _imei2Controller.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _imei1Controller.text.trim().isNotEmpty &&
        _imei2Controller.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF2563EB),
              child: Icon(Icons.notifications_none, color: Colors.white, size: 16),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF2563EB),
              child: Icon(Icons.search, color: Colors.white, size: 16),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is CustomerFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
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
                          setState(() {
                            if (type == 'sealFront') _sealFront = file;
                            if (type == 'sealBack') _sealBack = file;
                            if (type == 'imeiPhoto') _imeiPhoto = file;
                            if (type == 'invoicePhoto') _invoicePhoto = file;
                          });
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
                        onPressed: _isFormValid
                            ? () {
                          if (_formKey.currentState!.validate()) {
                            // Proceed with next logic or Bloc event
                          }
                        }
                            : null,
                        child: Text(
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
          );
        },
      ),
    );
  }
}