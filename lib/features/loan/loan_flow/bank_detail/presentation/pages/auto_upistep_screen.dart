import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';
import '../bloc/bank_detail_bloc.dart';
import '../bloc/bank_detail_event.dart';
import '../bloc/bank_detail_state.dart';
import 'web_view_screen.dart';

class AutoUpiStepScreen extends StatefulWidget {
  final String loanCode;
  final String emiNumbers;

  const AutoUpiStepScreen({
    super.key,
    required this.loanCode,
    required this.emiNumbers,
  });

  @override
  State<AutoUpiStepScreen> createState() => _AutoUpiStepScreenState();
}

class _AutoUpiStepScreenState extends State<AutoUpiStepScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedPaymentMode = 'Auto-UPI';
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BankDetailBloc>().add(SetupAutoUpiEvent("AOP-554"));
    });
  }

  void _openSetupWebView(String urlString, String merchantOrderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AutoUpiWebViewScreen(
          url: urlString,
          title: 'Auto UPI Setup',
        ),
      ),
    );

    if (result == true && mounted) {
      context.read<BankDetailBloc>().add(
        VerifyAndPostTransactionEvent(
          registrationId: "AOP-554",
          loanCode: widget.loanCode,
          emiNumbers: widget.emiNumbers,
        ),
      );
    }
  }

  void _openTransactionWebView(String urlString, String merchantOrderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AutoUpiWebViewScreen(
          url: urlString,
          title: 'Complete Payment',
        ),
      ),
    );

    if (result == true && mounted) {
      context.read<BankDetailBloc>().add(
        CheckOrderAndStepFourEvent(
          registrationId: "AOP-554",
          merchantOrderId: merchantOrderId,
        ),
      );
    }
  }

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
                      context.go(RouteNames.referenceStep);
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
    return BlocListener<BankDetailBloc, BankDetailState>(
      listener: (context, state) {
        if (state is AutoUpiUrlLoadedState) {
          _openSetupWebView(state.intentUrl, state.merchantOrderId);
        } else if (state is TransactionUrlLoadedState) {
          _openTransactionWebView(state.intentUrl, state.merchantOrderId);
        } else if (state is BankDetailSuccessState) {
          _showSuccessDialog();
        } else if (state is BankDetailErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.loanDetailStep);
          }
        },
        child: Scaffold(
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
          body: Column(
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
                                  context.go(RouteNames.bankDetailStep);
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
                        _buildLabel('UPI ID*'),
                        TextFormField(
                          controller: _upiIdController,
                          decoration: _inputDecoration('Enter UPI ID (e.g. name@oksbi)'),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter UPI ID';
                            }
                            final upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');
                            if (!upiRegex.hasMatch(val.trim())) {
                              return 'Please enter a valid UPI ID (e.g., name@oksbi / name@paytm)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            width: 280,
                            height: 280,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Icon(
                                    Icons.qr_code_2,
                                    size: 200,
                                    color: Colors.black.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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
                          context.read<BankDetailBloc>().add(
                            SetupAutoUpiEvent("AOP-554"),
                          );
                        }
                      },
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