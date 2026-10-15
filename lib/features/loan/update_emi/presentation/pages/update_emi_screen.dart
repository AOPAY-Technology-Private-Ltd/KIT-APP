import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../common/custom_app_bar.dart';
import '../../../customer_detail/presentation/widgets/custom_action_button.dart';
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

  int? _selectedStartingEmi;
  String? _selectedNumberOfEmisCount = '1';
  String? _selectedPaymentMode;
  String? _selectedStatus = 'Paid';
  File? _paymentPhotoFile;

  List<int> _availablePendingEmis = [];

  final TextEditingController _emiAmountController = TextEditingController();
  final TextEditingController _lateFeesController = TextEditingController(text: '0');
  final TextEditingController _bounceChargesController = TextEditingController(text: '0');
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _transactionIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UpdateEmiBloc>().add(FetchEmiDetailsEvent());
  }

  Future<void> _pickPaymentImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 80);

    if (image != null) {
      setState(() {
        _paymentPhotoFile = File(image.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Payment Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickPaymentImage(ImageSource.gallery);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library, color: Color(0xFF2563EB)),
                        SizedBox(width: 16),
                        Text('Choose from Gallery', style: TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _pickPaymentImage(ImageSource.camera);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        Icon(Icons.photo_camera, color: Color(0xFF2563EB)),
                        SizedBox(width: 16),
                        Text('Take a Photo', style: TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectPaymentDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    try {
      initialDate = DateFormat('dd MMM, yyyy').parse(_paymentDateController.text);
    } catch (_) {}

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _paymentDateController.text = DateFormat('dd MMM, yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<UpdateEmiBloc, UpdateEmiState>(
          listener: (context, state) {
            if (state is UpdateEmiSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
              );
              Navigator.pop(context);
            } else if (state is UpdateEmiError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
              );
            } else if (state is EmiDetailsLoadedState) {
              final details = state.emiDetails;

              _availableEmisListSetup(details);

              _emiAmountController.text = details.emiAmount.toString();
              _lateFeesController.text = details.lateFees.toString();
              _bounceChargesController.text = details.bounceCharges.toString();
              _transactionIdController.text = details.transactionId;
              _selectedNumberOfEmisCount = '1';

              List<String> validModes = ['Cash', 'UPI', 'Bank Transfer', 'Cheque'];
              if (validModes.contains(details.paymentMode)) {
                _selectedPaymentMode = details.paymentMode;
              }

              List<String> validStatuses = ['Paid', 'Pending', 'Failed'];
              if (validStatuses.contains(details.status)) {
                _selectedStatus = details.status;
              }

              if (details.nextDueDate.isNotEmpty) {
                try {
                  final parsedDate = DateTime.parse(details.nextDueDate);
                  _paymentDateController.text = DateFormat('dd MMM, yyyy').format(parsedDate);
                } catch (_) {
                  _paymentDateController.text = details.nextDueDate;
                }
              } else {
                _paymentDateController.text = DateFormat('dd MMM, yyyy').format(DateTime.now());
              }
              setState(() {});
            }
          },
          builder: (context, state) {
            final emiDetails = state is EmiDetailsLoadedState ? state.emiDetails : null;

            return Column(
              children: [
                CustomAppBar(
                  title: 'Update EMI',
                  onBackPressed: () => Navigator.pop(context),
                  onSearchPressed: () {},
                ),

                Expanded(
                  child: state is UpdateEmiLoading && emiDetails == null
                      ? const Center(child: CircularProgressIndicator())
                      : Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomerTopSummaryCard(
                            emiDetails: emiDetails,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'EMI Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(height: 16),

                          _buildLabel('Number Of EMIs to Pay'),
                          DropdownButtonFormField<String>(
                            value: _selectedNumberOfEmisCount,
                            decoration: _inputDecoration('-- Select Count --'),
                            items: ['1', '2', '3', '4'].map((val) => DropdownMenuItem(value: val, child: Text('$val EMI${val == '1' ? '' : 's'}'))).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedNumberOfEmisCount = val;
                                int count = int.tryParse(val ?? '1') ?? 1;
                                double baseAmount = emiDetails?.emiAmount ?? 0.0;
                                _emiAmountController.text = (baseAmount * count).toStringAsFixed(2);
                              });
                            },
                            validator: (val) => val == null || val.isEmpty ? 'Please select count' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('Payment Mode'),
                          DropdownButtonFormField<String>(
                            value: _selectedPaymentMode,
                            decoration: _inputDecoration('-- Select Payment Mode --'),
                            items: ['Cash', 'UPI', 'Bank Transfer', 'Cheque'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                            onChanged: (val) => setState(() => _selectedPaymentMode = val),
                            validator: (val) => val == null || val.isEmpty ? 'Please select payment mode' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('EMI Amount (₹)'),
                          TextFormField(
                            controller: _emiAmountController,
                            decoration: _inputDecoration(''),
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Enter EMI amount' : null,
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
                                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter late fees' : null,
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
                                      validator: (val) => val == null || val.trim().isEmpty ? 'Enter bounce charges' : null,
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
                            readOnly: true,
                            onTap: () => _selectPaymentDate(context),
                            decoration: _inputDecoration('').copyWith(
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF2563EB)),
                                onPressed: () => _selectPaymentDate(context),
                              ),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please select payment date' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('Status Update'),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: _inputDecoration(''),
                            items: ['Paid', 'Pending', 'Failed'].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
                            onChanged: (val) => setState(() => _selectedStatus = val),
                            validator: (val) => val == null || val.isEmpty ? 'Please select status' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('Transaction ID', isRequired: false),
                          TextFormField(
                            controller: _transactionIdController,
                            decoration: _inputDecoration('Enter Transaction ID (Optional)'),
                            validator: (val) => null,
                          ),
                          const SizedBox(height: 16),

                          _buildLabel('Payment Photo', isRequired: false),
                          GestureDetector(
                            onTap: () => _showImageSourceActionSheet(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF3B82F6),
                                  width: 1.5,
                                ),
                              ),
                              child: _paymentPhotoFile != null
                                  ? Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _paymentPhotoFile!,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _paymentPhotoFile!.path.split('/').last,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Color(0xFF0F172A),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Tap to change photo',
                                          style: TextStyle(
                                            color: Color(0xFF2563EB),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _paymentPhotoFile = null;
                                      });
                                    },
                                  ),
                                ],
                              )
                                  : const Column(
                                children: [
                                  Icon(Icons.cloud_upload_outlined, color: Color(0xFF3B82F6), size: 32),
                                  SizedBox(height: 8),
                                  Text('Upload Payment Photo (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                                  SizedBox(height: 4),
                                  Text('JPG, PNG or PDF (Max. 5MB)', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          PaymentSummaryCard(
                            dueAmount: double.tryParse(_emiAmountController.text) ?? (emiDetails?.emiAmount ?? 0.0),
                            totalPaid: 0.0,
                          ),
                          const SizedBox(height: 16),

                          const CautionBannerWidget(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    child: CustomActionButton(
                      title: 'Confirm & Mark Paid',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final int startingEmi = _selectedStartingEmi ?? (emiDetails?.nextEmiNumber ?? 1);

                          int count = int.tryParse(_selectedNumberOfEmisCount ?? '1') ?? 1;

                          List<int> selectedEmiNumbersList = List.generate(
                            count,
                                (index) => startingEmi + index,
                          );

                          final Map<String, dynamic> payload = {
                            'number_of_emi': count,
                            'selectedEmiNumbers': selectedEmiNumbersList,
                            'payment_mode': _selectedPaymentMode ?? 'Cash',
                            'emi_amount': double.tryParse(_emiAmountController.text) ?? 0.0,
                            'transaction_id': _transactionIdController.text,
                            'payment_photo': _paymentPhotoFile?.path ?? '',
                          };

                          context.read<UpdateEmiBloc>().add(SubmitEmiEvent(payload));
                        }
                      },
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

  void _availableEmisListSetup(dynamic details) {
    _availableEmisListSetupInternal(details.nextEmiNumber, details.totalEmiCount);
  }

  void _availableEmisListSetupInternal(int nextEmi, int totalCount) {
    _availableEmisListSetupFallback(nextEmi, totalCount);
  }

  void _availableEmisListSetupFallback(int nextEmi, int totalCount) {
    _availableEmisListSetupHelper(nextEmi, totalCount);
  }

  void _availableEmisListSetupHelper(int nextEmi, int totalCount) {
    _availablePendingEmis = [];
    int start = nextEmi > 0 ? nextEmi : 1;
    for (int i = start; i <= totalCount; i++) {
      _availablePendingEmis.add(i);
    }
    if (_availablePendingEmis.isNotEmpty) {
      _selectedStartingEmi = _availablePendingEmis.first;
    }
  }

  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
          ),
          if (isRequired)
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
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
    );
  }
}