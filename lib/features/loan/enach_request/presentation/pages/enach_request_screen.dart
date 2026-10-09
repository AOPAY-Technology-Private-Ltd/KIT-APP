import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/routes/route_names.dart';
import '../../../enach_review/domain/entities/enach_review_entity.dart';
import '../bloc/enach_request_bloc.dart';
import '../bloc/enach_request_state.dart';
import '../widgets/enach_card_widget.dart';

class EnachRequestScreen extends StatelessWidget {
  const EnachRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, -0.00),
                end: Alignment(0.50, 1.00),
                colors: [Color(0xFF2563EB), Color(0xFF002576)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 14, color: Color(0xFF2563EB)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'eNACH Request',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<EnachRequestBloc, EnachRequestState>(
              builder: (context, state) {
                if (state is EnachRequestLoadingState) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
                } else if (state is EnachRequestLoadedState) {
                  final requests = state.requests;
                  final pendingCount = requests.where((r) => r.status == 'Review').length;

                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2FE).withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$pendingCount requests need your review',
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Open the latest request to review the customer, current bank, requested bank, and account details before approving.',
                                    style: TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF08A),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$pendingCount Pending',
                                style: const TextStyle(
                                  color: Color(0xFF854D0E),
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pending requests (${requests.length})',
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Newest first',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ...requests.map((request) => EnachCardWidget(
                        request: request,
                        onTap: () {
                          final reviewEntity = EnachReviewEntity(
                            customerId: request.customerId,
                            customerName: request.customerName,
                            appliedDate: request.appliedDate,
                            imageUrl: request.imageUrl,
                            status: request.status,

                          );

                          context.push(RouteNames.enachReview, extra: reviewEntity);
                        },
                      )),
                    ],
                  );
                } else if (state is EnachRequestErrorState) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}