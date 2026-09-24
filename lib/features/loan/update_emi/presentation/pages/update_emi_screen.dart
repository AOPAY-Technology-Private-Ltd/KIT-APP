import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/custom_app_bar.dart';
import '../../../customer_detail/presentation/widgets/custom_action_button.dart';
import '../../domain/entities/emi_customer_entity.dart';
import '../bloc/update_emi_bloc.dart';
import '../bloc/update_emi_event.dart';
import '../bloc/update_emi_state.dart';
import '../widgets/customer_top_summary_card.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/caution_banner_widget.dart';

class UpdateEmiScreen extends StatefulWidget {
  const UpdateEmiScreen({super.key});

  @override
  State<UpdateEmiScreen> createState() => _UpdateEmiScreenState();
}

class _UpdateEmiScreenState extends State<UpdateEmiScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedNumberOfEmi;
  String? _selectedPaymentMode;
  String? _selectedStatus = 'Paid';

  final TextEditingController _emiAmountController = TextEditingController(text: '2250');
  final TextEditingController _lateFeesController = TextEditingController();
  final TextEditingController _bounceChargesController = TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController(text: '05 Oct, 2026');
  final TextEditingController _transactionIdController = TextEditingController(text: '428931204912');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: BlocConsumer<UpdateEmiBloc, UpdateEmiState>(
        listener: (context, state) {
          if (state is UpdateEmiSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is UpdateEmiError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Update EMI',
                    onBackPressed: () => Navigator.pop(context),
                    onSearchPressed: () {},
                  ),
                  const CustomerTopSummaryCard(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EMI Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(height: 12),

                        _buildLabel('Number Of EMI'),
                        DropdownButtonFormField<String>(
                          value: _selectedNumberOfEmi,
                          decoration: _inputDecoration('-- Select Number Of EMI --'),
                          items: ['1 EMI', '2 EMIs', '3 EMIs'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                          onChanged: (val) => setState(() => _selectedNumberOfEmi = val),
                          validator: (val) => val == null ? 'Please select number of EMI' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Payment Mode'),
                        DropdownButtonFormField<String>(
                          value: _selectedPaymentMode,
                          decoration: _inputDecoration('-- Select Payment Mode --'),
                          items: ['Cash', 'UPI', 'Bank Transfer', 'Cheque'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                          onChanged: (val) => setState(() => _selectedPaymentMode = val),
                          validator: (val) => val == null ? 'Please select payment mode' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('EMI Amount (₹)'),
                        TextFormField(
                          controller: _emiAmountController,
                          decoration: _inputDecoration(''),
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? 'Enter EMI amount' : null,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Late Fees'),
                                  TextFormField(
                                    controller: _lateFeesController,
                                    decoration: _inputDecoration('Enter Late Fees'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Bounce Charges'),
                                  TextFormField(
                                    controller: _bounceChargesController,
                                    decoration: _inputDecoration('Enter Bounce Charges'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Payment Date'),
                        TextFormField(
                          controller: _paymentDateController,
                          decoration: _inputDecoration('').copyWith(
                            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Status Update'),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: _inputDecoration(''),
                          items: ['Paid', 'Pending', 'Failed'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                          onChanged: (val) => setState(() => _selectedStatus = val),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Transaction ID'),
                        TextFormField(
                          controller: _transactionIdController,
                          decoration: _inputDecoration(''),
                          validator: (val) => val!.isEmpty ? 'Enter Transaction ID' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Payment Photo'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF3B82F6)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.cloud_upload_outlined, color: Color(0xFF3B82F6), size: 32),
                              SizedBox(height: 8),
                              Text('Payment Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                              SizedBox(height: 4),
                              Text('JPG, PNG or PDF (Max. 5MB)', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const PaymentSummaryCard(),
                        const SizedBox(height: 16),

                        const CautionBannerWidget(),
                        const SizedBox(height: 24),

                        CustomActionButton(
                          title: 'Confirm & Mark Paid',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final entity = EmiUpdateEntity(
                                loanId: 'LN-2026-10069',
                                numberOfEmi: _selectedNumberOfEmi ?? '',
                                paymentMode: _selectedPaymentMode ?? '',
                                emiAmount: double.tryParse(_emiAmountController.text) ?? 0.0,
                                lateFees: double.tryParse(_lateFeesController.text),
                                bounceCharges: double.tryParse(_bounceChargesController.text),
                                paymentDate: _paymentDateController.text,
                                status: _selectedStatus ?? 'Paid',
                                transactionId: _transactionIdController.text,
                              );
                              context.read<UpdateEmiBloc>().add(SubmitEmiEvent(entity));
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 13)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB))),
    );
  }
}