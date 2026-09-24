import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../create_customer/presentation/widgets/custom_header.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_state.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16),
              child: const CustomHeader(title: 'Notification'),
            ),

            SizedBox(height: 22,),

            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationLoaded) {
                    if (state.notifications.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    return _buildNotificationList(state);
                  } else if (state is NotificationError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.notifications_off_outlined,
            size: 100,
            color: Colors.blue.shade200,
          ),
          const SizedBox(height: 24),
          const Text(
            'No Notification',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF022062),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              onPressed: () => context.pop(),
              child: const Text(
                'Back to Home screen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNotificationList(NotificationLoaded state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = state.notifications[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead ? Colors.grey.shade50 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.isRead ? Colors.grey.shade200 : Colors.blue.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}