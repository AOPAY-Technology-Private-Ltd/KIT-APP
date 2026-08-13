import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inventory_entity.dart';
import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';
import '../widgtes/inventory_filters_widget.dart';
import '../widgtes/inventory_group_list_widget.dart';
import '../widgtes/inventory_header_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading || state is InventoryInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2563EB)),
            );
          }

          if (state is InventoryError) {
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
                        context.read<InventoryBloc>().add(LoadInventoryEvent());
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry', style: TextStyle(fontFamily: 'Inter')),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is InventoryLoaded) {
            Map<String, List<InventoryItem>> groupedItems = {};
            for (var item in state.filteredItems) {
              groupedItems.putIfAbsent(item.groupMonth, () => []).add(item);
            }

            return Column(
              children: [
                InventoryHeaderWidget(counts: state.counts),
                if (state.allItems.isNotEmpty)
                  InventoryFiltersWidget(currentFilter: state.currentFilter),

                Expanded(
                  child: InventoryGroupListWidget(
                    groupedItems: groupedItems,
                    filteredItems: state.filteredItems,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}