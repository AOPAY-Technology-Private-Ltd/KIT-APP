import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/routes/route_names.dart';
import '../../../../common/custom_gradient_button.dart';
import '../../../../common/custom_icon_button.dart';
import '../../../../common/custom_search_icon_button.dart';
import '../../../create_loan/presentation/widgets/step_progress_header.dart';
import '../bloc/reference_bloc.dart';
import '../bloc/reference_event.dart';
import '../bloc/reference_state.dart';

class ReferenceStepScreen extends StatefulWidget {
  const ReferenceStepScreen({super.key});

  @override
  State<ReferenceStepScreen> createState() => _ReferenceStepScreenState();
}

class _ReferenceStepScreenState extends State<ReferenceStepScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _relationshipController.dispose();
    _mobileNumberController.dispose();
    _addressController.dispose();
    super.dispose();
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
          context.go(RouteNames.emandateStep);
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
                    context.go(RouteNames.emandateStep);
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
        body: BlocConsumer<ReferenceBloc, ReferenceState>(
          listener: (context, state) {
            debugPrint('Current ReferenceState: $state');

            if (state is ReferenceSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reference Details Submitted Successfully!'), backgroundColor: Colors.green),
              );

              context.go(RouteNames.termsConditionStep);

            } else if (state is ReferenceErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const StepProgressHeader(currentStep: 6),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '6. Reference Detail',
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
                                  Expanded(child: _buildFirstNameField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildLastNameField()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Enter Relationship'),
                              TextFormField(
                                controller: _relationshipController,
                                decoration: _inputDecoration('Enter Relationship'),
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Enter Mobile number'),
                              TextFormField(
                                controller: _mobileNumberController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: _inputDecoration('Enter Mobile Number').copyWith(
                                  counterText: '',
                                ),
                                validator: (val) {
                                  if (val != null && val.trim().isNotEmpty && val.trim().length != 10) {
                                    return 'Please enter a valid 10-digit mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Enter Address'),
                              TextFormField(
                                controller: _addressController,
                                maxLines: 2,
                                decoration: _inputDecoration('Enter Address'),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
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
                          text: 'Next',
                          isLoading: state is ReferenceLoadingState,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ReferenceBloc>().add(
                                SubmitReferenceEvent(
                                  firstName: _firstNameController.text.trim(),
                                  lastName: _lastNameController.text.trim(),
                                  relationship: _relationshipController.text.trim(),
                                  mobileNumber: _mobileNumberController.text.trim(),
                                  address: _addressController.text.trim(),
                                ),
                              );
                            }
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

  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('First Name*'),
        TextFormField(
          controller: _firstNameController,
          decoration: _inputDecoration('Enter First Name'),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Please enter first name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLastNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Last Name*'),
        TextFormField(
          controller: _lastNameController,
          decoration: _inputDecoration('Enter Last Name'),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return 'Please enter last name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
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