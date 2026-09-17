import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer_detail_entity.dart';
import '../../data/models/app_master_model.dart';
import '../bloc/customer_detail_bloc.dart';

class CustomerActionInfoCard extends StatelessWidget {
  final CustomerDetailEntity customer;
  final AppMasterModel appMaster;
  final Map<String, bool> actionToggles;
  final Map<String, Map<String, bool>> selectedSubItems;

  const CustomerActionInfoCard({
    super.key,
    required this.customer,
    required this.appMaster,
    required this.actionToggles,
    required this.selectedSubItems,
  });

  List<Map<String, String>> _getSubItemsWithCodes(String categoryTitle) {
    try {
      final category = appMaster.categories.firstWhere((cat) => cat.actionName == categoryTitle);
      return category.subactionList.map((sub) => {
        'name': sub.subactionName,
        'code': sub.packageName.isNotEmpty ? sub.packageName : sub.subactionName,
      }).toList();
    } catch (_) {
      return [];
    }
  }

  void _onToggleClicked(BuildContext context, String categoryTitle) {
    final subItemsList = _getSubItemsWithCodes(categoryTitle);

    String categoryNotificationCode = 'LOCK_DEVICE';
    try {
      final category = appMaster.categories.firstWhere((cat) => cat.actionName == categoryTitle);
      categoryNotificationCode = category.notificationCode;
    } catch (_) {}

    if (subItemsList.isNotEmpty) {
      _showSelectionPopup(context, categoryTitle, categoryNotificationCode, subItemsList);
    } else {
      final currentVal = actionToggles[categoryTitle] ?? false;
      final newVal = !currentVal;

      BlocProvider.of<CustomerDetailBloc>(context).add(
        SaveDeviceActionEvent(
          customerCode: customer.customerCode,
          notificationCode: categoryNotificationCode,
          actionStatus: newVal,
          devicePin: '',
          selectedApps: [{
            "packageName": categoryNotificationCode,
            "actionStatus": newVal,
          }],
        ),
      );
    }
  }

  void _showSelectionPopup(BuildContext mainContext, String categoryTitle, String categoryNotificationCode, List<Map<String, String>> subItemsList) {
    final Map<String, bool> existingSubMap = selectedSubItems[categoryTitle] ?? {};
    final Map<String, bool> itemsMap = {};

    for (var sub in subItemsList) {
      final name = sub['name']!;
      final code = sub['code']!;
      bool isPreviouslyChecked = existingSubMap[name] == true || existingSubMap[code] == true;
      itemsMap[name] = isPreviouslyChecked;
    }

    showDialog(
      context: mainContext,
      builder: (dialogContext) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            final filteredSubItems = subItemsList.where((sub) =>
                sub['name']!.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();

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
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(builderContext).size.height * 0.75,
                  ),
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
                                    for (var sub in subItemsList) {
                                      itemsMap[sub['name']!] = newValue;
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

                      TextField(
                        onChanged: (value) {
                          setDialogState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontFamily: 'Inter'),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB), size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Flexible(
                        child: filteredSubItems.isEmpty
                            ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'No items found',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontFamily: 'Inter'),
                            ),
                          ),
                        )
                            : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: filteredSubItems.map((sub) {
                              final itemKey = sub['name']!;
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
                            Navigator.pop(dialogContext);

                            final List<Map<String, dynamic>> finalAppsToSubmit = subItemsList.map((sub) {
                              final bool isChecked = itemsMap[sub['name']!] ?? false;
                              return {
                                "packageName": sub['code']!,
                                "actionStatus": isChecked,
                              };
                            }).toList();

                            final bool categoryActionStatus = itemsMap.values.any((val) => val == true);

                            BlocProvider.of<CustomerDetailBloc>(mainContext).add(
                              SaveDeviceActionEvent(
                                customerCode: customer.customerCode,
                                notificationCode: categoryNotificationCode,
                                actionStatus: categoryActionStatus,
                                devicePin: '',
                                selectedApps: finalAppsToSubmit,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Save & Secure',
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
            ...appMaster.categories.map((cat) {
              final bool isToggled = actionToggles[cat.actionName] ?? cat.check;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildCustomToggleRow(context, cat.actionName, isToggled),
              );
            }),
            _buildActionBtnRow('SIM Tracking Online', 'Track', () {}),
            const SizedBox(height: 10),
            _buildActionBtnRow('SIM Tracking Offline', 'Track', () {}),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<CustomerDetailBloc>(context).add(
                SaveDeviceActionEvent(
                  customerCode: customer.customerCode,
                  notificationCode: 'APP_UNINSTALL',
                  actionStatus: false,
                  devicePin: '',
                  selectedApps: [
                    {"packageName": "Uninstall", "actionStatus": false}
                  ],
                ),
              );
            },
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
              const SizedBox(
                width: 16,
                height: 16,
                child: Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF2563EB)),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtnRow(String title, String btnText, VoidCallback onTap) {
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
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF343434))),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              minimumSize: const Size(60, 24),
              padding: EdgeInsets.zero,
            ),
            child: Text(btnText, style: const TextStyle(fontSize: 10, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}