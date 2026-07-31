import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inventory_entity.dart';
import '../bloc/inventory_bloc.dart';
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
            return Center(child: Text(state.message));
          }

          if (state is InventoryLoaded) {
            Map<String, List<InventoryItem>> groupedItems = {};
            for (var item in state.filteredItems) {
              groupedItems.putIfAbsent(item.groupMonth, () => []).add(item);
            }

            return Column(
              children: [
                InventoryHeaderWidget(counts: state.counts),

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