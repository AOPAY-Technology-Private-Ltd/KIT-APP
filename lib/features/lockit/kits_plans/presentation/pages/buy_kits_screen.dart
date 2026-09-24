import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logkit/features/lockit/kits_plans/presentation/pages/payment_webview_screen.dart';
import '../../../../../core/constants/routes/route_names.dart';
import '../../../../../core/services/session_manager.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../../data/datasources/buy_kits_remote_data_source.dart';
import '../../data/models/plan_model.dart';
import '../../data/models/save_purchase_history_request_model.dart';
import '../../data/repositories/buy_kits_repository_impl.dart';
import '../../domain/usecaes/buy_kits_usecases.dart';
import '../../domain/usecaes/trigger_payment_gateway_usecase.dart';
import '../../domain/usecaes/save_purchase_history_usecase.dart';
import '../bloc/buy_kits_bloc.dart';
import '../widgtes/bill_breakdown_widget.dart';
import '../widgtes/plan_card_widget.dart';

class BuyKitsScreen extends StatefulWidget {
  const BuyKitsScreen({super.key});

  @override
  State<BuyKitsScreen> createState() => _BuyKitsScreenState();
}

class _BuyKitsScreenState extends State<BuyKitsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = BuyKitsRemoteDataSourceImpl(client: http.Client());
    final repository = BuyKitsRepositoryImpl(remoteDataSource);

    return BlocProvider(
      create: (context) => BuyKitsBloc(
        GetBuyKitsDataUseCase(repository),
        TriggerPaymentGatewayUseCase(repository),
      )..add(LoadBuyKitsData()),
      child: BlocListener<BuyKitsBloc, BuyKitsState>(
        listener: (context, state) async {
          if (state.paymentFormHtml != null && state.paymentFormHtml!.isNotEmpty) {
            final retailerCode = await SessionManager.getRetailerCode() ?? '';
            final plan = state.selectedPlan as PlanModel;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentWebViewScreen(
                  htmlFormContent: state.paymentFormHtml!,
                  savePurchaseHistoryUseCase: SavePurchaseHistoryUseCase(repository),
                  requestModel: SavePurchaseHistoryRequestModel(
                    companyCode: "CMP0005",
                    purchaseCode: "PUR000001",
                    retailerCode: retailerCode,
                    mappingCode: plan.mappingCode,
                    planCode: plan.planCode,
                    planAmount: state.subtotal,
                    discountAmount: 0.0,
                    gstAmount: state.gstAmount,
                    netAmount: state.totalAmount,
                    paymentMode: "UPI",
                    transactionNo: "TXN_${DateTime.now().millisecondsSinceEpoch}",
                    paymentReferenceNo: "REF_${DateTime.now().millisecondsSinceEpoch}",
                    paymentStatus: "SUCCESS",
                    purchaseDate: DateTime.now().toIso8601String(),
                    planStartDate: DateTime.now().toIso8601String().split('T')[0],
                    planEndDate: DateTime.now().add(const Duration(days: 365)).toIso8601String().split('T')[0],
                    invoiceNo: "INV_${DateTime.now().millisecondsSinceEpoch}",
                    remarks: "Plan purchased successfully via UPI",
                    isActive: true,
                    createdBy: "Admin",
                  ),
                ),
              ),
            );
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      CustomHeader(
                        title: 'Buy Lock Kits',
                        showSearch: true,
                        onNotificationTap: () => context.push(RouteNames.notification),
                        onSearchTap: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                              context.read<BuyKitsBloc>().add(SearchBuyKitsEvent(''));
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      if (_isSearching) ...[
                        TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: (query) {
                            context.read<BuyKitsBloc>().add(SearchBuyKitsEvent(query));
                          },
                          decoration: InputDecoration(
                            hintText: 'Search plans...',
                            hintStyle: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.black54),
                              onPressed: () {
                                _searchController.clear();
                                context.read<BuyKitsBloc>().add(SearchBuyKitsEvent(''));
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF3F6FF),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      const SizedBox(height: 6),

                      Expanded(
                        child: BlocBuilder<BuyKitsBloc, BuyKitsState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF008EFD),
                                ),
                              );
                            }

                            if (state.plans.isEmpty) {
                              return Center(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.search_off_rounded,
                                        size: 55,
                                        color: Color(0xff2563EB),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'No Plans Found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                          color: Color(0xff2563EB),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'No results match your search or filter criteria.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Inter',
                                          color: Colors.black.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Choose a Plan',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Save more on bigger bundles. GST 18% included at checkout.',
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.50),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.45,
                                    ),
                                    itemCount: state.plans.length,
                                    itemBuilder: (context, index) {
                                      final plan = state.plans[index];
                                      final isSelected = state.selectedPlan?.id == plan.id;
                                      return PlanCardWidget(
                                        plan: plan,
                                        isSelected: isSelected,
                                        onTap: () {
                                          BlocProvider.of<BuyKitsBloc>(context).add(SelectPlanEvent(plan));
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  if (state.selectedPlan != null)
                                    BillBreakdownWidget(
                                      selectedPlan: state.selectedPlan!,
                                      gstPercentage: state.gstPercentage,
                                      subtotal: state.subtotal,
                                      gstAmount: state.gstAmount,
                                      totalAmount: state.totalAmount,
                                    ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<BuyKitsBloc, BuyKitsState>(
            builder: (context, state) {
              if (state.plans.isEmpty || state.isLoading) {
                return const SizedBox.shrink();
              }
              return SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF008EFD),
                          Color(0xFF022062),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: state.isSubmitting
                            ? null
                            : () {
                          BlocProvider.of<BuyKitsBloc>(context).add(
                            SubmitPaymentEvent(
                              phoneNo: "9876543210",
                              customerCode: "CUST001",
                              customerName: "Test Customer",
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pay ₹${state.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Row(
                                children: [
                                  state.isSubmitting
                                      ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : const Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}