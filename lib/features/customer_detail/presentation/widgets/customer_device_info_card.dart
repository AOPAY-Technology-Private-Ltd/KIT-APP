import 'package:flutter/material.dart';
import '../../domain/entities/customer_detail_entity.dart';

class CustomerDeviceInfoCard extends StatelessWidget {
  final CustomerDetailEntity customer;

  const CustomerDeviceInfoCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DeviceFieldRow(label: 'Device Name', value: customer.deviceName ?? 'N/A'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'Brand', value: customer.brand ?? 'Realme'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'Manufacturer', value: customer.manufacturer ?? 'Realme'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'Model', value: customer.model ?? 'Realme RMX5256'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'IMEI Slot 1', value: customer.imeiSlot1 ?? customer.imei),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'IMEI Slot 2', value: customer.imeiSlot2 ?? '-'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'Serial Number', value: customer.serialNumber ?? 'N/A'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'OS Version', value: customer.osVersion ?? 'N/A'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'SDK Version', value: customer.sdkVersion ?? 'N/A'),
          const SizedBox(height: 12),
          _DeviceFieldRow(label: 'App Version', value: customer.appVersion ?? 'N/A'),
          // const SizedBox(height: 12),
          // _DeviceFieldRow(label: 'Purchase Date', value: customer.purchaseDate ?? '09-06-2026, 17:18:28'),
          const SizedBox(height: 12),
          _DeviceActionRow(
            label: 'Device Pin',
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Set Pin', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 12),
          _DeviceActionRow(
            label: 'Generate OUC Code',
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Generate', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceFieldRow extends StatelessWidget {
  final String label;
  final String value;

  const _DeviceFieldRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.80),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Text(' :  ', style: TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.80),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeviceActionRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DeviceActionRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.80),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Text(' :  ', style: TextStyle(color: Colors.grey)),
        Expanded(child: Align(alignment: Alignment.centerLeft, child: child)),
      ],
    );
  }
}