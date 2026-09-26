import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../domain/entities/loan_detail_entity.dart';
import '../bloc/loan_detail_bloc.dart';
import '../bloc/loan_detail_event.dart';
import '../bloc/loan_detail_state.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';

class LoanDetailStepScreen extends StatefulWidget {
  const LoanDetailStepScreen({super.key});

  @override
  State<LoanDetailStepScreen> createState() => _LoanDetailStepScreenState();
}

class _LoanDetailStepScreenState extends State<LoanDetailStepScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController(text: '2200');
  final TextEditingController _downPaymentController = TextEditingController();
  final TextEditingController _processFeesController = TextEditingController(text: '399');
  final TextEditingController _forecloseChargesController = TextEditingController();

  String? _selectedInterestType;
  double _tenureMonths = 6.0;
  double _interestRate = 18.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF022062),
        elevation: 0,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CustomHeaderIconButton(
              child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF022062), size: 12),
              onTap: () {
                context.go(RouteNames.basicDetailsStep);
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
      body: BlocConsumer<LoanDetailBloc, LoanDetailState>(
        listener: (context, state) {
          if (state is LoanDetailSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Loan details saved successfully!'), backgroundColor: Colors.green),
            );
            // API success hone ke baad hi bank detail step par navigate karein
            context.push(RouteNames.bankDetailStep);
          } else if (state is LoanDetailErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const StepProgressHeader(currentStep: 3),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '3. Loan Detail',
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Product Category*'),
                                  TextFormField(
                                    controller: _productCategoryController,
                                    decoration: _inputDecoration('Enter Product Category'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Brand*'),
                                  TextFormField(
                                    controller: _brandController,
                                    decoration: _inputDecoration('Enter Brand Name'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Model*'),
                                  TextFormField(
                                    controller: _modelController,
                                    decoration: _inputDecoration('Enter Model Name'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Loan Amount*'),
                                  TextFormField(
                                    controller: _loanAmountController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration('Enter Loan Amount'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Down Payment*'),
                                  TextFormField(
                                    controller: _downPaymentController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration('Enter Down Payment'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Process Fees*'),
                                  TextFormField(
                                    controller: _processFeesController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration('Enter Process Fees'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Foreclose Charges*'),
                                  TextFormField(
                                    controller: _forecloseChargesController,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration('Enter Foreclose Charges'),
                                    validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Interest Type*'),
                                  DropdownButtonFormField<String>(
                                    value: _selectedInterestType,
                                    isExpanded: true,
                                    decoration: _inputDecoration('-- Select Interest Type --'),
                                    items: ['Flat', 'Reducing'].map((type) {
                                      return DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 12)));
                                    }).toList(),
                                    onChanged: (val) => setState(() => _selectedInterestType = val),
                                    validator: (val) => val == null || val.isEmpty ? 'Select Type' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Customize EMI',
                          style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Adjust down payment and tenure to see your EMI',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.10)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Tenure', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontFamily: 'Inter')),
                                  Text('${_tenureMonths.toInt()} Months', style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter')),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  double maxWidth = constraints.maxWidth;
                                  double progressWidth = ((_tenureMonths / 60) * maxWidth).clamp(0.0, maxWidth);
                                  double thumbLeft = (progressWidth - 4).clamp(0.0, maxWidth - 8);

                                  return GestureDetector(
                                    onPanUpdate: (details) {
                                      setState(() {
                                        double dx = details.localPosition.dx;
                                        double value = (dx / maxWidth) * 60;
                                        _tenureMonths = value.clamp(0.0, 60.0);
                                      });
                                    },
                                    onTapDown: (details) {
                                      setState(() {
                                        double dx = details.localPosition.dx;
                                        double value = (dx / maxWidth) * 60;
                                        _tenureMonths = value.clamp(0.0, 60.0);
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 6,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFD9D9D9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: progressWidth,
                                            height: 6,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFF2563EB),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: thumbLeft,
                                            top: -4,
                                            child: Container(
                                              width: 8,
                                              height: 14,
                                              decoration: ShapeDecoration(
                                                color: const Color(0xFF94B5FF),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                shadows: const [
                                                  BoxShadow(
                                                    color: Color(0xCC000000),
                                                    blurRadius: 2,
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Interest Rate', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                    const Text('18% p.a', style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Monthly EMI', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text('${_tenureMonths.toInt()} Month', style: const TextStyle(color: Colors.white, fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                    const Text('₹ 386 /month', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Payment Summary',
                          style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: Colors.black.withValues(alpha: 0.10),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildSummaryRow('Loan Amount', '₹ 2,200.00'),
                              _buildSummaryRow('Interest', '₹ 116.00'),
                              _buildSummaryRow('Processing Fee', '₹ 399.00'),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF07B609),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Total Payable',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '₹ 2,786.82.00',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                      isLoading: state is LoanDetailLoadingState,
                      onPressed: () {
                        // Yeh check karega ki form ki saari required fields bhari hain ya nahi
                        if (_formKey.currentState!.validate()) {
                          final entity = LoanDetailEntity(
                            productCategory: _productCategoryController.text.trim(),
                            brand: _brandController.text.trim(),
                            model: _modelController.text.trim(),
                            loanAmount: _loanAmountController.text.trim(),
                            downPayment: _downPaymentController.text.trim(),
                            processFees: _processFeesController.text.trim(),
                            forecloseCharges: _forecloseChargesController.text.trim(),
                            interestType: _selectedInterestType ?? '',
                            tenure: _tenureMonths,
                            interestRate: _interestRate,
                          );

                          // API submit event dispatch hoga
                          BlocProvider.of<LoanDetailBloc>(context).add(SubmitLoanDetailEvent(entity));
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.50),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.70),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.black.withValues(alpha: 0.40),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.black.withValues(alpha: 0.40),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF2563EB),
        ),
      ),
    );
  }
}