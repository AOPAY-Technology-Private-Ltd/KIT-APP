import 'package:flutter/material.dart';

import 'core/constants/routes/app_router.dart';
import 'core/di/injection.dart';
import 'core/helper/device_helper.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await init();

    DeviceHelper.initDeviceData();
  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}