import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/routes/app_router.dart';
import 'core/di/injection.dart';
import 'core/helper/device_helper.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    await init();
    DeviceHelper.initDeviceData();

    await _fetchAndSaveFCMToken();

  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  runApp(const MyApp());
}

Future<void> _fetchAndSaveFCMToken() async {
  try {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? fcmToken = await messaging.getToken();
    if (fcmToken != null && fcmToken.isNotEmpty) {
      debugPrint("--- FCM Token Fetched Successfully: $fcmToken ---");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', fcmToken);
    } else {
      debugPrint("--- FCM Token is Null or Empty ---");
    }
  } catch (e) {
    debugPrint("Error fetching FCM token during startup: $e");
  }
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