import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../../domain/entities/entities.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_state.dart';
import '../widgtes/history_search_bar.dart';
import '../widgtes/invoice_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomHeader(title: 'History'),
            ),

            const HistorySearchBar(),

            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                    );
                  } else if (state is HistoryLoaded) {
                    if (state.filteredInvoices.isEmpty) {
                      return const Center(child: Text("No Invoices Found"));
                    }

                    final Map<String, List<Invoice>> groupedInvoices = {};
                    for (var invoice in state.filteredInvoices) {
                      groupedInvoices.putIfAbsent(invoice.sectionCategory, () => []).add(invoice);
                    }

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
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...entry.value.map((invoice) => InvoiceCard(invoice: invoice)),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    );
                  } else if (state is HistoryError) {
                    return Center(child: Text(state.message));
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