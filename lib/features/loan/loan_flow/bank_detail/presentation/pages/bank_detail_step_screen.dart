import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../domain/entities/bank_detail_entity.dart';
import '../bloc/bank_detail_bloc.dart';
import '../bloc/bank_detail_event.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bank details saved successfully!'), backgroundColor: Colors.green),
            );
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
                                onTap: () => setState(() => _selectedPaymentMode = 'E-Nach'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _selectedPaymentMode == 'E-Nach' ? const Color(0xFF2563EB) : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _selectedPaymentMode == 'E-Nach' ? const Color(0xFF2563EB) : Colors.black.withValues(alpha: 0.15),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'E-Nach',
                                    style: TextStyle(
                                      color: _selectedPaymentMode == 'E-Nach' ? Colors.white : const Color(0xFF0F172A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedPaymentMode = 'Auto-UPI'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _selectedPaymentMode == 'Auto-UPI' ? const Color(0xFF2563EB) : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _selectedPaymentMode == 'Auto-UPI' ? const Color(0xFF2563EB) : Colors.black.withValues(alpha: 0.15),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Auto-UPI',
                                    style: TextStyle(
                                      color: _selectedPaymentMode == 'Auto-UPI' ? Colors.white : const Color(0xFF0F172A),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
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

                        _buildLabel('Enter Branch Name*'),
                        TextFormField(
                          controller: _branchNameController,
                          decoration: _inputDecoration('Enter Branch Name'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter Branch Name' : null,
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
                      isLoading: state is BankDetailLoadingState,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final entity = BankDetailEntity(
                            paymentMode: _selectedPaymentMode,
                            bankName: _selectedBank ?? '',
                            accountType: _selectedAccountType ?? '',
                            accountNumber: _accountNumberController.text.trim(),
                            confirmAccountNumber: _confirmAccountNumberController.text.trim(),
                            beneficiaryName: _beneficiaryNameController.text.trim(),
                            ifscCode: _ifscCodeController.text.trim(),
                            branchName: _branchNameController.text.trim(),
                          );
                          BlocProvider.of<BankDetailBloc>(context).add(SubmitBankDetailEvent(entity));
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