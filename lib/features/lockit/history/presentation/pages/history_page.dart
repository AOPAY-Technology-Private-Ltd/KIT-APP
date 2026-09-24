import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/routes/route_names.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../../domain/entities/entities.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgtes/invoice_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<HistoryBloc>();
    if (bloc.state is HistoryInitial) {
      bloc.add(LoadHistoryEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _isSearching
                  ? Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                      });
                      context.read<HistoryBloc>().add(SearchHistoryEvent(''));
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2563EB)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (query) {
                          context.read<HistoryBloc>().add(SearchHistoryEvent(query));
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search Invoice...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Inter'),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : CustomHeader(
                title: 'History',
                showBackButton: false,
                showSearch: true,
                onNotificationTap: () => context.push(RouteNames.notification),
                onSearchTap: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                    );
                  } else if (state is HistoryLoaded) {
                    if (state.filteredInvoices.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.receipt_long_outlined,
                                  size: 48,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No Invoices Found",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "You don't have any purchase history yet.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final Map<String, List<Invoice>> groupedInvoices = {};
                    for (var invoice in state.filteredInvoices) {
                      groupedInvoices.putIfAbsent(invoice.sectionCategory, () => []).add(invoice);
                    }

                    int globalIndex = 0;

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: groupedInvoices.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF64748B),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...entry.value.map((invoice) {
                              final currentIndex = globalIndex++;
                              return InvoiceCard(invoice: invoice, index: currentIndex);
                            }),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    );
                  } else if (state is HistoryError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                context.read<HistoryBloc>().add(LoadHistoryEvent());
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Retry', style: TextStyle(fontFamily: 'Inter')),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}