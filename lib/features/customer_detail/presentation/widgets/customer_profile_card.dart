import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/customer_detail_entity.dart';
import '../bloc/customer_detail_bloc.dart';
import '../bloc/customer_detail_state.dart';

class CustomerProfileCard extends StatefulWidget {
  final CustomerDetailEntity customer;

  const CustomerProfileCard({super.key, required this.customer});

  @override
  State<CustomerProfileCard> createState() => _CustomerProfileCardState();
}

class _CustomerProfileCardState extends State<CustomerProfileCard> {
  late bool isLocked;
  late bool isInactive;
  late String displayStatus;

  @override
  void initState() {
    super.initState();
    _updateStatus();
  }

  @override
  void didUpdateWidget(covariant CustomerProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateStatus();
  }

  void _updateStatus() {
    final status = widget.customer.status.trim();
    isLocked = status.toLowerCase() == 'locked' || status.toLowerCase() == 'lock';
    isInactive = status.toLowerCase() == 'inactive';

    if (status.toLowerCase() == 'approved') {
      displayStatus = 'Approved';
    } else if (isInactive) {
      displayStatus = 'Inactive';
    } else if (isLocked) {
      displayStatus = 'Locked';
    } else {
      displayStatus = status.isNotEmpty ? status : 'Unlocked';
    }
  }

  Color _getStatusColor() {
    final lower = displayStatus.toLowerCase();
    if (lower == 'approved') {
      return const Color(0xFF0A7804);
    } else if (lower == 'inactive') {
      return const Color(0xFFF97316);
    } else if (lower == 'locked') {
      return const Color(0xFFDC2626);
    } else {
      return const Color(0xFF3B82F6);
    }
  }

  void _showInactiveRestrictionDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Color(0xFFDC2626),
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Action Restricted',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This customer is currently inactive. You cannot perform any device actions until the status is updated.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
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

  void _showLocationDetailsBottomSheet(BuildContext context) {
    final bloc = context.read<CustomerDetailBloc>();
    final state = bloc.state;

    Map<String, dynamic> locationData = {};
    if (state is CustomerDetailLoaded && state.locationKitData != null) {
      locationData = state.locationKitData!;
    } else if (bloc.latestLocationKitData != null) {
      locationData = bloc.latestLocationKitData!;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest Location Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              if (locationData.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      'No location data available.',
                      style: TextStyle(color: Colors.grey, fontFamily: 'Inter', fontSize: 14),
                    ),
                  ),
                )
              else
                ...locationData.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: Color(0xFF475569),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${entry.value}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showLockFlowDialog({
    required BuildContext parentContext,
    required String customerCode,
    required String notificationCode,
  }) {
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isPinStep = true;
        bool isLoading = false;
        String enteredPin = '';
        final List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());
        final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: StatefulBuilder(
              builder: (innerContext, setInnerState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPinStep) ...[
                      const Text(
                        'Set Customer Screen PIN',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please enter a 4-digit PIN for the device',
                        style: TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: KeyboardListener(
                              focusNode: FocusNode(),
                              onKeyEvent: (event) {
                                if (event is KeyDownEvent &&
                                    event.logicalKey == LogicalKeyboardKey.backspace) {
                                  if (controllers[index].text.isEmpty && index > 0) {
                                    focusNodes[index - 1].requestFocus();
                                    controllers[index - 1].clear();
                                  }
                                }
                              },
                              child: TextField(
                                controller: controllers[index],
                                focusNode: focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                obscureText: true,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  counterText: '',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (index < 3) {
                                      focusNodes[index + 1].requestFocus();
                                    }
                                  } else {
                                    if (index > 0) {
                                      focusNodes[index - 1].requestFocus();
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading ? null : () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color(0xFFF8FAFC),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                String pin = controllers.map((c) => c.text).join();
                                if (pin.length == 4) {
                                  enteredPin = pin;

                                  setInnerState(() {
                                    isLoading = true;
                                  });

                                  parentContext.read<CustomerDetailBloc>().add(
                                    SaveDeviceActionEvent(
                                      customerCode: customerCode,
                                      notificationCode: notificationCode,
                                      actionStatus: true,
                                      devicePin: enteredPin,
                                      selectedApps: [
                                        {
                                          "packageName": notificationCode,
                                          "actionStatus": true,
                                        }
                                      ],
                                    ),
                                  );

                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    if (dialogContext.mounted) {
                                      setInnerState(() {
                                        isLoading = false;
                                        isPinStep = false;
                                      });
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(parentContext).showSnackBar(
                                    const SnackBar(content: Text('Please enter complete 4-digit PIN')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Image.asset(
                          'assets/images/lock.gif',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Lock this Device?',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This Customer will loose full access to their phone immediately',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                side: const BorderSide(color: Color(0xFF2563EB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext, rootNavigator: true).pop();

                                showDialog(
                                  context: parentContext,
                                  barrierDismissible: false,
                                  builder: (loadingContext) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                );

                                Future.microtask(() {
                                  parentContext.read<CustomerDetailBloc>().add(
                                    SaveDeviceActionEvent(
                                      customerCode: customerCode,
                                      notificationCode: 'LOCK_DEVICE',
                                      actionStatus: true,
                                      devicePin: enteredPin,
                                      selectedApps: [
                                        {
                                          "packageName": "LOCK_DEVICE",
                                          "actionStatus": true,
                                        }
                                      ],
                                    ),
                                  );

                                  parentContext.read<CustomerDetailBloc>().add(
                                    LockDeviceEvent(widget.customer.id.toString()),
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Lock',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showUnlockActionDialog({
    required BuildContext parentContext,
    required String customerCode,
    required String notificationCode,
  }) {
    showDialog(
      context: parentContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Image.asset(
                    'assets/images/lock.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Unlock this Device?',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This Customer will regain full access to their phone immediately',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext, rootNavigator: true).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext, rootNavigator: true).pop();

                          showDialog(
                            context: parentContext,
                            barrierDismissible: false,
                            builder: (loadingContext) => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF00B22D),
                              ),
                            ),
                          );

                          Future.microtask(() {
                            parentContext.read<CustomerDetailBloc>().add(
                              SaveDeviceActionEvent(
                                customerCode: customerCode,
                                notificationCode: notificationCode,
                                actionStatus: true,
                                selectedApps: [
                                  {
                                    "packageName": notificationCode,
                                    "actionStatus": true,
                                  }
                                ],
                              ),
                            );

                            parentContext.read<CustomerDetailBloc>().add(
                              UnlockDeviceEvent(widget.customer.id.toString()),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B22D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Unlock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  widget.customer.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.customer.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: _getStatusColor(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                displayStatus,
                                style: TextStyle(
                                  color: _getStatusColor(),
                                  fontSize: 8,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.customer.customerCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isInactive) {
                        _showInactiveRestrictionDialog();
                      } else {
                        _showLocationDetailsBottomSheet(context);
                      }
                    },
                    child: _buildCardIcon(Icons.location_on_outlined),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: isInactive ? _showInactiveRestrictionDialog : null,
                    child: _buildCardIcon(Icons.notifications_active_outlined),
                  ),
                ],
              ),
              CustomPaint(
                painter: const GlassBorderPainter(borderRadius: 45),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0x33D9D9D9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isInactive) {
                            _showInactiveRestrictionDialog();
                          } else {
                            _showUnlockActionDialog(
                              parentContext: context,
                              customerCode: widget.customer.customerCode,
                              notificationCode: 'UNLOCK_DEVICE',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: ShapeDecoration(
                            color: !isLocked && !isInactive ? Colors.white : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            shadows: !isLocked && !isInactive
                                ? [
                              const BoxShadow(
                                color: Color(0x66000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_open,
                                size: 10,
                                color: (!isLocked && !isInactive) ? const Color(0xFF3B82F6) : Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Unlock',
                                style: TextStyle(
                                  color: (!isLocked && !isInactive) ? const Color(0xFF3B82F6) : Colors.white70,
                                  fontSize: 8,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      GestureDetector(
                        onTap: () {
                          if (isInactive) {
                            _showInactiveRestrictionDialog();
                          } else {
                            _showLockFlowDialog(
                              parentContext: context,
                              customerCode: widget.customer.customerCode,
                              notificationCode: 'DEVICE_PIN',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: ShapeDecoration(
                            color: (isLocked && !isInactive) ? const Color(0xFFDC2626) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            shadows: (isLocked && !isInactive)
                                ? [
                              const BoxShadow(
                                color: Color(0xBF000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                size: 10,
                                color: isInactive ? Colors.white70 : Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Lock',
                                style: TextStyle(
                                  color: isInactive ? Colors.white70 : Colors.white,
                                  fontSize: 8,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GlassBorderPainter extends CustomPainter {
  final double borderRadius;
  const GlassBorderPainter({this.borderRadius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.8),
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    if (borderRadius > 0) {
      canvas.drawRRect(rRect, paint);
    } else {
      canvas.drawOval(rect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}