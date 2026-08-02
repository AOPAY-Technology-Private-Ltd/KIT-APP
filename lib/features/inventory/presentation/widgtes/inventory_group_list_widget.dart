import 'package:flutter/material.dart';
import '../../domain/entities/inventory_entity.dart';

class InventoryGroupListWidget extends StatelessWidget {
  final Map<String, List<InventoryItem>> groupedItems;
  final List<InventoryItem> filteredItems;

  const InventoryGroupListWidget({
    super.key,
    required this.groupedItems,
    required this.filteredItems,
  });

  @override
  Widget build(BuildContext context) {
    final entries = groupedItems.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: entries.length,
      itemBuilder: (context, groupIndex) {
        final entry = entries[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: groupIndex == 0 ? 4 : 12,
                bottom: 8,
              ),
              child: Text(
                entry.key,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.60),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.10)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: entry.value.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                itemBuilder: (context, index) {
                  final item = entry.value[index];
                  final globalIndex = filteredItems.indexOf(item);
                  return _buildInventoryItemRow(item, globalIndex);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInventoryItemRow(InventoryItem item, int index) {
    final displayIndex = '#${(index + 1).toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 26,
            decoration: ShapeDecoration(
              color: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              displayIndex,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.serialNumber,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  item.assignedUser,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.50),
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Installed On',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.40),
                  fontSize: 8,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '${item.installedDate.day} ${_getMonthName(item.installedDate.month)}, ${item.installedDate.year}',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.80),
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}