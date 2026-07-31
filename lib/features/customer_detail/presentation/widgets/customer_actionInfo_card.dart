import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer_detail_entity.dart';
import '../bloc/customer_detail_bloc.dart';
import '../bloc/customer_detail_event.dart';

class CustomerActionInfoCard extends StatelessWidget {
  final CustomerDetailEntity customer;
  final Map<String, bool> actionToggles;
  final Map<String, Map<String, bool>> selectedSubItems;

  const CustomerActionInfoCard({
    super.key,
    required this.customer,
    required this.actionToggles,
    required this.selectedSubItems,
  });

  static const Map<String, List<String>> _categoryItems = {
    'Social Apps': ['Whatsapp', 'Facebook', 'Instagram', 'Youtube', 'Snapchat', 'Linkedin'],
    'UPI Apps': ['Google Pay', 'PhonePe', 'Paytm', 'BHIM', 'Amazon Pay', 'Cred'],
    'Gaming Apps': ['PUBG Mobile', 'Free Fire', 'BGMI', 'Call of Duty', 'Ludo King', 'Subway Surfers'],
    'Disable Call': ['Incoming Calls', 'Outgoing Calls', 'International Calls', 'Roaming Calls'],
    'Disable Settings': ['App Settings', 'Network Settings', 'System Settings', 'Developer Options'],
    'KIOSK Mode': ['Single App Mode', 'Multi App Mode', 'Notification Bar Lock', 'Power Button Lock'],
    'Disable Camera': ['Front Camera', 'Rear Camera', 'Video Recording', 'QR Scanner'],
    'Reboot': ['Force Restart', 'Safe Mode Reboot', 'Remote Shutdown'],
    'Airplane Mode': ['Cellular Data', 'Wi-Fi', 'Bluetooth', 'GPS'],
    'App Hide': ['Banking Apps', 'Private Vault', 'Social Media Apps', 'Hidden Folders'],
    'SIM Remove Lock': ['SIM 1 Lock', 'SIM 2 Lock', 'E-SIM Lock', 'Network Lock'],
  };

  void _onToggleClicked(BuildContext context, String title) {
    if (_categoryItems.containsKey(title)) {
      _showSelectionPopup(context, title);
    } else {
      final currentVal = actionToggles[title] ?? false;
      BlocProvider.of<CustomerDetailBloc>(context).add(
        UpdateActionToggleEvent(
          categoryTitle: title,
          updatedSubItems: {title: !currentVal},
        ),
      );
    }
  }

  void _showSelectionPopup(BuildContext mainContext, String categoryTitle) {
    if (!_categoryItems.containsKey(categoryTitle)) return;

    final customerBloc = BlocProvider.of<CustomerDetailBloc>(mainContext);

    final List<String> subKeys = _categoryItems[categoryTitle]!;

    final Map<String, bool> existingSubMap = selectedSubItems[categoryTitle] ?? {};
    final Map<String, bool> itemsMap = {};

    for (var key in subKeys) {
      itemsMap[key] = existingSubMap[key] ?? false;
    }

    showDialog(
      context: mainContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            bool allSelected = itemsMap.isNotEmpty && itemsMap.values.every((v) => v == true);

            return Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: MediaQuery.of(builderContext).size.width * 0.85,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: allSelected,
                                activeColor: const Color(0xFF2563EB),
                                onChanged: (val) {
                                  setDialogState(() {
                                    final bool newValue = val ?? false;
                                    for (var k in subKeys) {
                                      itemsMap[k] = newValue;
                                    }
                                  });
                                },
                              ),
                              Text(
                                'Select $categoryTitle',
                                style: const TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: const Icon(Icons.cancel, color: Color(0xFFDC2626), size: 24),
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 8),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: subKeys.map((itemKey) {
                              final bool isChecked = itemsMap[itemKey] ?? false;

                              return InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    itemsMap[itemKey] = !isChecked;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: isChecked,
                                          activeColor: const Color(0xFF2563EB),
                                          onChanged: (val) {
                                            setDialogState(() {
                                              itemsMap[itemKey] = val ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          itemKey,
                                          style: const TextStyle(
                                            color: Color(0xFF343434),
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            customerBloc.add(
                              UpdateActionToggleEvent(
                                categoryTitle: categoryTitle,
                                updatedSubItems: Map<String, bool>.from(itemsMap),
                              ),
                            );
                            Navigator.pop(dialogContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            _buildCustomToggleRow(context, 'Social Apps', actionToggles['Social Apps'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'UPI Apps', actionToggles['UPI Apps'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'Gaming Apps', actionToggles['Gaming Apps'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'Disable Call', actionToggles['Disable Call'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'Disable Settings', actionToggles['Disable Settings'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'KIOSK Mode', actionToggles['KIOSK Mode'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'Disable Camera', actionToggles['Disable Camera'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'Reboot', actionToggles['Reboot'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'Airplane Mode', actionToggles['Airplane Mode'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'App Hide', actionToggles['App Hide'] ?? false),
            const SizedBox(height: 10),
            _buildCustomToggleRow(context, 'SIM Remove Lock', actionToggles['SIM Remove Lock'] ?? false),
            const SizedBox(height: 10),
            _buildActionBtnRow('SIM Tracking Online', 'Track', () {}),
            const SizedBox(height: 10),
            _buildActionBtnRow('SIM Tracking Offline', 'Track', () {}),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text(
              'Uninstall',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomToggleRow(BuildContext context, String title, bool value) {
    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: ShapeDecoration(
        color: const Color(0xFFECF2FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.17,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _onToggleClicked(context, title),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 20,
              padding: const EdgeInsets.all(2),
              decoration: ShapeDecoration(
                color: value ? const Color(0xFF10B981) : const Color(0xFFDDDDDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Align(
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: double.infinity,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0xB2000000),
                        blurRadius: 2,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtnRow(String title, String btnText, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: ShapeDecoration(
        color: const Color(0xFFECF2FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              btnText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}