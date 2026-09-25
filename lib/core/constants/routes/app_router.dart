import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/loan/customer_detail/presentation/bloc/customer_bloc.dart' as new_customer;
import '../../../features/loan/customer_detail/presentation/pages/customer_detail_screen.dart';
import '../../../features/loan/customer_list/presentation/bloc/loan_customer_bloc.dart';
import '../../../features/loan/customer_list/presentation/bloc/loan_customer_event.dart';
import '../../../features/loan/customer_list/presentation/pages/loan_customer_list_page.dart';
import '../../../features/loan/loan_flow/create_loan/presentation/bloc/create_loan_bloc.dart';
import '../../../features/loan/loan_flow/create_loan/presentation/pages/documents_step_screen.dart';
import '../../../features/loan/loan_home_page/presentation/bloc/loan_home_bloc.dart';
import '../../../features/loan/loan_home_page/presentation/bloc/loan_home_event.dart' as loan_event;
import '../../../features/loan/loan_home_page/presentation/pages/loan_all_customers_screen.dart';
import '../../../features/loan/loan_home_page/presentation/pages/loan_home_page.dart';
import '../../../features/loan/loan_home_page/presentation/pages/loan_main_screen.dart';
import '../../../features/loan/loan_reports/presentation/bloc/loan_report_bloc.dart';
import '../../../features/loan/loan_reports/presentation/bloc/loan_report_event.dart';
import '../../../features/loan/loan_reports/presentation/pages/loan_reports_screen.dart';
import '../../../features/loan/update_emi/presentation/bloc/update_emi_bloc.dart';
import '../../../features/loan/update_emi/presentation/pages/update_emi_screen.dart';
import '../../../features/lockit/auth/presentation/Login/bloc/login_bloc.dart';
import '../../../features/lockit/auth/presentation/Login/pages/login_page.dart';
import '../../../features/lockit/auth/presentation/signup/bloc/signup_bloc.dart';
import '../../../features/lockit/auth/presentation/signup/pages/personal_details_page.dart';
import '../../../features/lockit/auth/presentation/signup/pages/signup_page.dart';
import '../../../features/lockit/auth/presentation/verifyotp/bloc/otp_bloc.dart';
import '../../../features/lockit/auth/presentation/verifyotp/pages/otp_verification_view.dart';
import '../../../features/lockit/create_customer/presentation/bloc/customer_bloc.dart';
import '../../../features/lockit/create_customer/presentation/pages/create_customer_view.dart';
import '../../../features/lockit/create_customer/presentation/pages/customer_info_view.dart';
import '../../../features/lockit/create_customer/presentation/pages/imei_number_view.dart';
import '../../../features/lockit/customer_detail/presentation/pages/customer_information_view.dart';
import '../../../features/lockit/customer_detail/presentation/widgets/device_status_success_view.dart';
import '../../../features/lockit/customer_list/presentation/pages/customer_list_view.dart';
import '../../../features/lockit/device_list/presentation/pages/device_list_view.dart';
import '../../../features/lockit/history/presentation/bloc/history_bloc.dart';
import '../../../features/lockit/history/presentation/bloc/history_event.dart';
import '../../../features/lockit/history/presentation/pages/history_page.dart';
import '../../../features/lockit/home/presentation/bloc/home_bloc.dart';
import '../../../features/lockit/home/presentation/bloc/home_event.dart';
import '../../../features/lockit/home/presentation/pages/main_screen.dart';
import '../../../features/lockit/inventory/presentation/bloc/inventory_bloc.dart';
import '../../../features/lockit/inventory/presentation/pages/inventory_screen.dart';
import '../../../features/lockit/kits_plans/presentation/bloc/buy_kits_bloc.dart';
import '../../../features/lockit/kits_plans/presentation/pages/buy_kits_screen.dart';
import '../../../features/lockit/kits_plans/presentation/pages/payment_success_screen.dart';
import '../../../features/lockit/notification/presentation/bloc/notification_bloc.dart';
import '../../../features/lockit/notification/presentation/bloc/notification_event.dart';
import '../../../features/lockit/notification/presentation/pages/notification_view.dart';
import '../../../features/lockit/profile/presentation/bloc/profile_bloc.dart';
import '../../../features/lockit/profile/presentation/bloc/profile_event.dart';
import '../../../features/lockit/profile/presentation/pages/profile_screen.dart';
import '../../../features/lockit/qr_code/presentation/bloc/qr_bloc.dart';
import '../../../features/lockit/qr_code/presentation/bloc/qr_event.dart';
import '../../../features/lockit/qr_code/presentation/pages/qr_code_view.dart';
import '../../../features/lockit/qr_code/presentation/pages/success_view.dart';
import '../../../features/lockit/qr_code/presentation/pages/token_validation_view.dart';
import '../../../features/lockit/splash/presentation/pages/splash_page.dart';
import '../../../features/lockit/support_screen/presentation/bloc/support_bloc.dart';
import '../../../features/lockit/support_screen/presentation/bloc/support_event.dart';
import '../../../features/lockit/support_screen/presentation/pages/support_screen.dart';

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

    GoRoute(
      path: RouteNames.loanHome,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<LoanHomeBloc>()..add(loan_event.LoadHomeDataEvent()),
          child: const LaonHomePage(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.loanAllCustomers,
      builder: (context, state) {
        return const LoanAllCustomersScreen();
      },
    ),

    GoRoute(
      path: RouteNames.loanMain,
      builder: (context, state) {
        return const LoanMainScreen();
      },
    ),

    GoRoute(
      path: RouteNames.loanCustomerList,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<LoanCustomerBloc>()..add(FetchLoanCustomersEvent(status: 'Active')),
          child: const LoanCustomerListPage(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.loanReports,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<LoanReportBloc>()..add(FetchLoanReportsEvent(status: 'All')),
        child: const LoanReportsScreen(),
      ),
    ),

    GoRoute(
      path: RouteNames.customerDetailNew,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<new_customer.CustomerBloc>(),
          child: const CustomerDetailScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.updateEmi,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<UpdateEmiBloc>(),
          child: const UpdateEmiScreen(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.documentsStep,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<CreateLoanBloc>(),
          child: const DocumentsStepScreen(),
        );
      },
    ),
  ],
);