import 'dart:math';
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

  List<String> _bankList = [];

  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _confirmAccountNumberController = TextEditingController();
  final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BankDetailBloc>().add(FetchBankListEvent('AOP-554'));
  }

  void _showBankSearchModal() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final filteredList = _bankList.where((bank) {
              return bank.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Bank',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search bank...',
                        hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.3), fontSize: 12),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filteredList.isEmpty
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'No data found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          : ListView.builder(
                        itemCount: filteredList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final String bankName = filteredList[index];

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedBank = bankName;
                              });

                              Navigator.of(sheetContext).pop();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                bankName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
          if (state is BankBankListLoadedState) {
            setState(() {
              _bankList = state.banks;
            });
          } else if (state is BankDetailSuccessState) {
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
                        FormField<String>(
                          validator: (val) => _selectedBank == null || _selectedBank!.isEmpty ? 'Please select bank' : null,
                          builder: (FormFieldState<String> field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: _showBankSearchModal,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: field.hasError ? Colors.red : Colors.black.withValues(alpha: 0.40),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _selectedBank ?? '--- Select Bank ---',
                                            style: TextStyle(
                                              color: _selectedBank == null ? Colors.black.withValues(alpha: 0.30) : const Color(0xFF0F172A),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6, left: 12),
                                    child: Text(
                                      field.errorText!,
                                      style: const TextStyle(color: Colors.red, fontSize: 11, fontFamily: 'Inter'),
                                    ),
                                  ),
                              ],
                            );
                          },
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
                      isLoading: state is BankDetailLoadingState,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final bankDetailEntity = BankDetailEntity(
                            paymentMode: _selectedPaymentMode,
                            bankName: _selectedBank ?? '',
                            accountType: _selectedAccountType ?? '',
                            accountNumber: _accountNumberController.text.trim(),
                            confirmAccountNumber: _confirmAccountNumberController.text.trim(),
                            beneficiaryName: _beneficiaryNameController.text.trim(),
                            ifscCode: _ifscCodeController.text.trim(),
                            branchName: _branchNameController.text.trim(),
                          );

                          context.read<BankDetailBloc>().add(SubmitBankDetailEvent(bankDetailEntity));
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