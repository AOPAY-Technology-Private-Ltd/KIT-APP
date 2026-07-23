import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/Login/bloc/login_bloc.dart';
import '../../../features/auth/presentation/Login/pages/login_page.dart';

import '../../../features/auth/presentation/signup/bloc/signup_bloc.dart';
import '../../../features/auth/presentation/signup/pages/personal_details_page.dart';
import '../../../features/auth/presentation/signup/pages/signup_page.dart';

import '../../../features/auth/presentation/verifyotp/bloc/otp_bloc.dart';
import '../../../features/auth/presentation/verifyotp/pages/otp_verification_view.dart';
import '../../../features/splash/presentation/pages/splash_page.dart';

import '../../../features/home/presentation/bloc/home_bloc.dart';
import '../../../features/home/presentation/bloc/home_event.dart';
import '../../../features/home/presentation/pages/home_page.dart';

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
      path: RouteNames.signup,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<SignupBloc>(),
          child: const SignupView(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.home,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<HomeBloc>()..add(LoadHomeDataEvent()),
          child: const HomePage(),
        );
      },
    ),

    GoRoute(
      path: RouteNames.personalDetails,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return BlocProvider(
          create: (_) => sl<SignupBloc>(),
          child: PersonalDetailsView(
            businessName: data["businessName"],
            businessType: data["businessType"],
            gstType: data["gstType"],
          ),
        );
      },
    ),
    GoRoute(
      path: RouteNames.otpVerification,
      builder: (context, state) {
        final mobile = state.extra as String;

        return BlocProvider(
          create: (_) => sl<OtpBloc>(),
          child: OtpVerificationView(
            mobile: mobile,
          ),
        );
      },
    ),
  ],
);

