import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';
import '../bloc/emandate_bloc.dart';
import '../bloc/emandate_event.dart';
import '../bloc/emandate_state.dart';

class EmandateStepScreen extends StatefulWidget {
  const EmandateStepScreen({super.key});

  @override
  State<EmandateStepScreen> createState() => _EmandateStepScreenState();
}

class _EmandateStepScreenState extends State<EmandateStepScreen> {
  bool _isAuthorized = false;

  void _submitEmandate() {
    if (!_isAuthorized) {
      setState(() {
        _isAuthorized = true;
      });
    }
    BlocProvider.of<EmandateBloc>(context).add(
      SubmitEmandateEvent(_isAuthorized),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(RouteNames.bankDetailStep);
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
                    context.go(RouteNames.bankDetailStep);
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
        body: BlocConsumer<EmandateBloc, EmandateState>(
          listener: (context, state) {
            if (state is EmandateSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('E-Mandate Confirmed Successfully!'), backgroundColor: Colors.green),
              );
              context.go(RouteNames.referenceStep);
            } else if (state is EmandateErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const StepProgressHeader(currentStep: 5),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '5. E-Mandate Confirmation',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'ECS Auto-Debit Agreement',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'By selecting ECS (Electronic Clearing Service), I hereby authorize AO Pay to debit my registered bank account for EMI payments.',
                          style: TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'I understand and agree to the following:',
                          style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildBulletPoint('I have provided correct bank account details.'),
                        _buildBulletPoint('I authorize debit on scheduled EMI dates.'),
                        _buildBulletPoint('I will maintain sufficient balance.'),
                        _buildBulletPoint('I am responsible for penalties in case of failure.'),
                        _buildBulletPoint('This mandate remains valid until dues are cleared.'),
                        _buildBulletPoint('Cancellation may take a few working days.'),
                        _buildBulletPoint('I agree to the loan terms and conditions.'),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isAuthorized = !_isAuthorized;
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _isAuthorized,
                                  activeColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) {
                                    setState(() {
                                      _isAuthorized = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'I authorize the auto-debit of EMI through ECS and agree to the terms and conditions.',
                                  style: TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                        isLoading: state is EmandateLoadingState,
                        onPressed: () {
                          if (!_isAuthorized) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please authorize the auto-debit checkbox to proceed.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          _submitEmandate();
                        },
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 12,
                fontFamily: 'Inter',
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}