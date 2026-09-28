import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../bloc/bank_detail_bloc.dart';
import '../bloc/bank_detail_state.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';

class BankDetailStepScreen extends StatefulWidget {
  const BankDetailStepScreen({super.key});

  @override
  State<BankDetailStepScreen> createState() => _BankDetailStepScreenState();
}

class _BankDetailStepScreenState extends State<BankDetailStepScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedPaymentMode = 'E-Nach';
  String? _selectedBank;
  String? _selectedAccountType;

  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _confirmAccountNumberController = TextEditingController();
  final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(8, (index) {
                      final angle = (index * 45) * pi / 180;
                      return Transform.translate(
                        offset: Offset(38 * cos(angle), 38 * sin(angle)),
                        child: Container(
                          width: index % 2 == 0 ? 6 : 4,
                          height: index % 2 == 0 ? 6 : 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bank Details Verified\nSuccessfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0066FF), Color(0xFF022062)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(RouteNames.emandateStep);
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
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
                  context.go(RouteNames.loanDetailStep);
                }
              },
            ),
          ),
        ),
        title: const Text(
          'Add Customer',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
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
      body: BlocConsumer<BankDetailBloc, BankDetailState>(
        listener: (context, state) {
          if (state is BankDetailSuccessState) {
            _showSuccessDialog();
          } else if (state is BankDetailErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const StepProgressHeader(currentStep: 4),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '4. Bank Detail',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedPaymentMode = 'E-Nach');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: _selectedPaymentMode == 'E-Nach' ? const Color(0xFF2563EB) : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: _selectedPaymentMode == 'E-Nach' ? const Color(0xFF2563EB) : Colors.black.withValues(alpha: 0.15),
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'E-Nach',
                                    style: TextStyle(
                                      color: _selectedPaymentMode == 'E-Nach' ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedPaymentMode = 'Auto-UPI');
                                  context.go(RouteNames.autoUpiStep);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: _selectedPaymentMode == 'Auto-UPI' ? const Color(0xFF2563EB) : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: _selectedPaymentMode == 'Auto-UPI' ? const Color(0xFF2563EB) : Colors.black.withValues(alpha: 0.15),
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Auto-UPI',
                                    style: TextStyle(
                                      color: _selectedPaymentMode == 'Auto-UPI' ? Colors.white : const Color(0xFF0F172A),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Select Bank*'),
                        DropdownButtonFormField<String>(
                          value: _selectedBank,
                          isExpanded: true,
                          decoration: _inputDecoration('--- Select Bank ---'),
                          items: ['HDFC Bank', 'ICICI Bank', 'SBI', 'Axis Bank'].map((bank) {
                            return DropdownMenuItem(value: bank, child: Text(bank, style: const TextStyle(fontSize: 12)));
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedBank = val),
                          validator: (val) => val == null || val.isEmpty ? 'Please select bank' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Select Account Type*'),
                        DropdownButtonFormField<String>(
                          value: _selectedAccountType,
                          isExpanded: true,
                          decoration: _inputDecoration('--- Select Account Type ---'),
                          items: ['Savings', 'Current'].map((type) {
                            return DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 12)));
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedAccountType = val),
                          validator: (val) => val == null || val.isEmpty ? 'Please select account type' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Account Number*'),
                        TextFormField(
                          controller: _accountNumberController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Enter Account Number'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter Account Number' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Confirm Account Number*'),
                        TextFormField(
                          controller: _confirmAccountNumberController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Enter Confirm Account Number'),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Confirm Account Number';
                            if (val.trim() != _accountNumberController.text.trim()) return 'Account numbers do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Beneficiary Name*'),
                        TextFormField(
                          controller: _beneficiaryNameController,
                          decoration: _inputDecoration('Enter Beneficiary Name'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter Beneficiary Name' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('IFSC Code*'),
                        TextFormField(
                          controller: _ifscCodeController,
                          decoration: _inputDecoration('Enter IFSC Code'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter IFSC Code' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Branch Name*'),
                        TextFormField(
                          controller: _branchNameController,
                          decoration: _inputDecoration('Enter Branch Name'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter Branch Name' : null,
                        ),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showSuccessDialog();
                        }
                      },
                    ),
                  ),
                ),
              ),
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
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.30),
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1, color: Colors.black.withValues(alpha: 0.40)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1, color: Colors.black.withValues(alpha: 0.40)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 1, color: Color(0xFF2563EB)),
      ),
    );
  }
}