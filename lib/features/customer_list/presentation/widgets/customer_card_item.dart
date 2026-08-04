import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/routes/route_names.dart';
import '../../domain/entities/customer_item_entity.dart';

class CustomerCardItem extends StatelessWidget {
  final CustomerItemEntity customer;

  const CustomerCardItem({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // customer.id ki jagah customer.mobile pass kiya ja raha hai taaki API me sahi mobile number jaye
        context.push('${RouteNames.customerDetails}/${customer.mobile}');
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 380,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFEAF0FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const ShapeDecoration(
                            color: Colors.white24,
                            shape: OvalBorder(),
                          ),
                          child: ClipOval(
                            child: customer.imageUrl.isNotEmpty
                                ? Image.network(
                              customer.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultAvatar(),
                            )
                                : _buildDefaultAvatar(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${customer.name} (${customer.customerIdCode})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                customer.email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: ShapeDecoration(
                      color: customer.isLocked ? Colors.red : const Color(0xFF09B248),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone_android_outlined,
                          size: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.isLocked ? 'Locked' : 'Unlocked',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Mobile', customer.mobile),
                  const SizedBox(height: 6),
                  _buildInfoRow('IMEI 1', customer.imei1),
                  const SizedBox(height: 6),
                  _buildInfoRow('IMEI 2', customer.imei2),
                  const SizedBox(height: 6),
                  _buildInfoRow('Serial Number', customer.serialNumber),
                  const SizedBox(height: 6),
                  _buildInfoRow('Purchase Date', customer.purchaseDate),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    'Schedule Lock Status',
                    customer.scheduleLockStatus,
                    isStatus: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      size: 18,
      color: Colors.white,
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.80),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.80),
            fontSize: 11,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isStatus
                  ? (value.toUpperCase() == 'ON' ? const Color(0xFF04A609) : Colors.red)
                  : Colors.black.withValues(alpha: 0.80),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: isStatus ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}