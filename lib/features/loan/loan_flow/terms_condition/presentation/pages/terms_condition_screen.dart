import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';
import '../bloc/terms_bloc.dart';
import '../bloc/terms_event.dart';
import '../bloc/terms_state.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.referenceStep);
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
                    context.go(RouteNames.referenceStep);
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
        body: BlocConsumer<TermsBloc, TermsState>(
          listener: (context, state) {
            if (state is TermsSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              context.go(RouteNames.loanDisbursedStep);
            } else if (state is TermsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const StepProgressHeader(currentStep: 7),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '7. Terms & Condition',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Date: 11-09-2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter')),
                            const SizedBox(height: 4),
                            const Text('To: Mohan Verma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter')),
                            const SizedBox(height: 16),
                            const Center(
                              child: Text(
                                'Delivery Advice',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text('Hello Test', style: TextStyle(fontSize: 13, fontFamily: 'Inter')),
                            const SizedBox(height: 12),
                            const Text('1. Product Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Inter')),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  _buildTableRow('A', 'Customer Name', 'Vijay Dinanath Chauhan'),
                                  _buildTableRow('B', 'Brand Name', 'Samsung'),
                                  _buildTableRow('C', 'Model Name', 'Galaxy S Series'),
                                  _buildTableRow('D', 'Loan Amount', '30000'),
                                  _buildTableRow('E', 'Process Fees', '1500'),
                                  _buildTableRow('F', 'EMI', '2500', isLast: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Thanking you,\nAO PAY', style: TextStyle(fontSize: 13, fontFamily: 'Inter', height: 1.4)),
                            const SizedBox(height: 16),
                            const Text(
                              'Terms & Conditions',
                              style: TextStyle(color: Color(0xFF022062), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                            ),
                            const SizedBox(height: 10),
                            _buildBulletPoint('This is a computer generated delivery advice (DA) and does not require any signature.'),
                            _buildBulletPoint('This DA is valid for 15 days from the date of issuance. For whatever reason, if the loan is not disbursed within 15 days of issuance of this DA, then AO PAY will not be liable to pay the dealer.'),
                            _buildBulletPoint('In case, if it is later found that customer has a different product or same product with different IMEI/Serial No. than the one mentioned on the invoice provided by the dealer, then AO PAY will not be liable to pay for that case.'),
                            _buildBulletPoint('Smart Phone must be delivered to the customer over the counter only against proper acknowledgement thereof.'),
                            _buildBulletPoint('Date on the invoice should be for the same date as the date on the DA. It is mandatory to capture IMEI/Serial No., EMI Months and Amount on the invoice.'),
                            _buildBulletPoint('At the time of delivery, dealer\'s staff needs to click & upload the picture of the below requirement through AO PAY Dealer\'s application.'),
                            _buildBulletPoint('Delivery Challan'),
                            _buildBulletPoint('Photo of the customer'),
                            _buildBulletPoint('IMEI No. with product image'),
                            _buildBulletPoint('The dealer has to check original photo ID proof of their customer before handing over any Goods. Dealer staff is expected to match:'),
                            _buildBulletPoint('Name in ID card must match DA'),
                            _buildBulletPoint('Photo in ID must match person receiving goods'),
                            _buildBulletPoint('It is the dealer\'s responsibility to have delivery proof with customer acknowledgement on records and to share it with AO PAY as and when requested.'),
                            _buildBulletPoint('Customer\'s actual Rate of Interest may vary from that mentioned in the Sanction Letter which is due to system logics and rounding off mechanism. However, customer\'s EMI amount will remain the same.'),
                            _buildBulletPoint('In case of customer raising concerns on defective/damaged product post-disbursal, it will be the dealer\'s responsibility to foreclose the loan via AO PAY.'),
                            _buildBulletPoint('Other charges pertain to cost incurred to pull customer\'s bureau details.'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _isAgreed,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                    activeColor: const Color(0xFF022062),
                                    onChanged: (val) {
                                      setState(() {
                                        _isAgreed = val ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'I Agreed to the terms and conditions.',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
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
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: CustomGradientButton(
                          text: state is TermsLoadingState ? 'Processing...' : 'Accept & Continue',
                          onPressed: state is TermsLoadingState
                              ? null
                              : () {
                            if (!_isAgreed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please agree to the terms and conditions first.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            context.read<TermsBloc>().add(
                              SubmitTermsEvent(isAccepted: _isAgreed),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTableRow(String code, String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Inter')),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, fontFamily: 'Inter', color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontFamily: 'Inter', height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}