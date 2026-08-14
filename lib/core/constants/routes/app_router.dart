import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/Login/bloc/login_bloc.dart';
import '../../../features/auth/presentation/Login/pages/login_page.dart';

import '../../../features/auth/presentation/signup/bloc/signup_bloc.dart';
import '../../../features/auth/presentation/signup/pages/signup_page.dart';
import '../../../features/auth/presentation/signup/pages/personal_details_page.dart';

import '../../../features/auth/presentation/verifyotp/bloc/otp_bloc.dart';
import '../../../features/auth/presentation/verifyotp/pages/otp_verification_view.dart';
import '../../../features/create_customer/presentation/bloc/customer_bloc.dart';
import '../../../features/create_customer/presentation/pages/create_customer_view.dart';
import '../../../features/create_customer/presentation/pages/customer_info_view.dart';
import '../../../features/create_customer/presentation/pages/imei_number_view.dart';
import '../../../features/customer_detail/presentation/pages/customer_information_view.dart';
import '../../../features/customer_detail/presentation/widgets/device_status_success_view.dart';
import '../../../features/customer_list/presentation/pages/customer_list_view.dart';
import '../../../features/device_list/presentation/pages/device_list_view.dart';
import '../../../features/history/presentation/bloc/history_bloc.dart';
import '../../../features/history/presentation/bloc/history_event.dart';
import '../../../features/history/presentation/pages/history_page.dart';
import '../../../features/home/presentation/bloc/home_bloc.dart';
import '../../../features/home/presentation/bloc/home_event.dart';
import '../../../features/home/presentation/pages/main_screen.dart';

import '../../../features/inventory/presentation/bloc/inventory_bloc.dart';
import '../../../features/inventory/presentation/pages/inventory_screen.dart';
import '../../../features/kits_plans/presentation/bloc/buy_kits_bloc.dart';
import '../../../features/kits_plans/presentation/pages/buy_kits_screen.dart';
import '../../../features/kits_plans/presentation/pages/payment_success_screen.dart';
import '../../../features/notification/presentation/bloc/notification_bloc.dart';
import '../../../features/notification/presentation/bloc/notification_event.dart';
import '../../../features/notification/presentation/pages/notification_view.dart';
import '../../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../../features/profile/presentation/bloc/profile_event.dart';
import '../../../features/profile/presentation/pages/profile_screen.dart';
import '../../../features/qr_code/presentation/bloc/qr_bloc.dart';
import '../../../features/qr_code/presentation/bloc/qr_event.dart';
import '../../../features/qr_code/presentation/pages/qr_code_view.dart';
import '../../../features/qr_code/presentation/pages/success_view.dart';
import '../../../features/qr_code/presentation/pages/token_validation_view.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';

import '../../../features/support_screen/presentation/bloc/support_bloc.dart';
import '../../../features/support_screen/presentation/bloc/support_event.dart';
import '../../../features/support_screen/presentation/pages/support_screen.dart';
import '../../di/injection.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) {
        return const SplashPage();
      },
    ),

    GoRoute(
      path: RouteNames.login,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<LoginBloc>(),
          child: const LoginView(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.otpVerification,
      builder: (context, state) {
        final mobileOrEmail = state.extra as String? ?? '';

        return BlocProvider(
          create: (_) => sl<OtpBloc>(),
          child: OtpVerificationView(
            mobile: mobileOrEmail,
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.signup,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<SignupBloc>(),
          child: const SignupView(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.selectDevice,
      builder: (context, state) {
        return const SelectDeviceView();
      },
    ),

    GoRoute(
      path: RouteNames.personalDetails,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<SignupBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<OtpBloc>(),
            ),
          ],
          child: PersonalDetailsView(
            businessName: data["businessName"],
            businessType: data["businessType"],
            gstNumber: data["gstNumber"],
          ),
        );
      },
    ),

    GoRoute(
      path: RouteNames.home,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<HomeBloc>()
            ..add(
              LoadHomeDataEvent(),
            ),
          child: const MainScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.customerInfo,
      builder: (context, state) {
        return const CustomerInfoView();
      },
    ),

    GoRoute(
      path: RouteNames.customerList,
      builder: (context, state) {
        return const CustomerListView();
      },
    ),

    GoRoute(
      path: RouteNames.createCustomer,
      builder: (context, state) {
        return CreateCustomerView();
      },
    ),

    GoRoute(
      path: '${RouteNames.customerDetails}/:mobile',
      builder: (context, state) {
        final customerMobile = state.pathParameters['mobile'] ?? '';
        return CustomerInformationView(customerMobile: customerMobile);
      },
    ),

    GoRoute(
      path: RouteNames.deviceStatusSuccess,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return DeviceStatusSuccessView(
          isLocked: data['isLocked'] ?? true,
          customerName: data['customerName'] ?? 'Customer',
          deviceName: data['deviceName'] ?? 'Device',
          reason: data['reason'] ?? 'EMI Overdue',
          time: data['time'] ?? 'Today, 9:42 AM',
          actionBy: data['actionBy'] ?? 'Retailer',
          onDonePressed: () {
            context.go(RouteNames.home);
          },
        );
      },
    ),

    GoRoute(
      path: RouteNames.history,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<HistoryBloc>()..add(LoadHistoryEvent()),
          child: const HistoryPage(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.inventory,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<InventoryBloc>(),
          child: InventoryScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.buyKits,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<BuyKitsBloc>(),
          child: BuyKitsScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(FetchProfileEvent()),
          child: const ProfileScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.imeiNumber,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<CustomerBloc>(),
          child: const ImeiNumberView(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.notification,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<NotificationBloc>()..add(FetchNotificationsEvent()),
          child: NotificationView(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.support,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<SupportBloc>()..add(LoadSupportDataEvent()),
          child: const SupportScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.paymentSuccess,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return PaymentSuccessScreen(
          orderId: data['orderId'] ?? 'INV-00000',
          kitsCount: data['kitsCount'] ?? 0,
          totalPaid: data['totalPaid'] ?? 0.0,
          paymentMethod: data['paymentMethod'] ?? 'UPI',
        );
      },
    ),

    GoRoute(
      path: RouteNames.qrCode,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<QrBloc>()..add(LoadQrDataEvent()),
          child: const QrCodeView(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.tokenValidation,
      builder: (context, state) {
        return const TokenValidationView();
      },
    ),

    GoRoute(
      path: RouteNames.installSuccess,
      builder: (context, state) {
        return const InstallSuccessView();
      },
    ),
  ],
);