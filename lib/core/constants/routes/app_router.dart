import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/Login/bloc/login_bloc.dart';
import '../../../features/auth/presentation/Login/pages/login_page.dart';

import '../../../features/auth/presentation/signup/bloc/signup_bloc.dart';
import '../../../features/auth/presentation/signup/pages/signup_page.dart';
import '../../../features/auth/presentation/signup/pages/personal_details_page.dart';

import '../../../features/auth/presentation/verifyotp/bloc/otp_bloc.dart';
import '../../../features/auth/presentation/verifyotp/pages/otp_verification_view.dart';
import '../../../features/create_customer/presentation/pages/create_customer_view.dart';
import '../../../features/create_customer/presentation/pages/customer_info_view.dart';
import '../../../features/customer_list/presentation/pages/customer_list_view.dart';
import '../../../features/device_list/presentation/pages/device_list_view.dart';
import '../../../features/home/presentation/bloc/home_bloc.dart';
import '../../../features/home/presentation/bloc/home_event.dart';
import '../../../features/home/presentation/pages/main_screen.dart';

import '../../../features/splash/presentation/pages/splash_page.dart';
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
        return const CreateCustomerView();
      },
    ),
  ],
);