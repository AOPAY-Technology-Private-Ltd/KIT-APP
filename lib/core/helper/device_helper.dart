import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceHelper {
  static Future<void> initDeviceData() async {
    final prefs = await SharedPreferences.getInstance();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String deviceId = prefs.getString('device_id') ?? '';
    String fcmToken = prefs.getString('fcm_token') ?? '';

    try {
      if (deviceId.isEmpty || deviceId.startsWith('unknown_device')) {
        if (Platform.isAndroid) {
          final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          deviceId = androidInfo.id;
        } else if (Platform.isIOS) {
          final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? 'ios_device';
        }
      }

      if (fcmToken.isEmpty || fcmToken == 'FALLBACK_FCM_TOKEN_12345') {
        for (int i = 0; i < 3; i++) {
          final token = await FirebaseMessaging.instance.getToken();
          if (token != null && token.isNotEmpty) {
            fcmToken = token;
            break;
          }
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      print('Error fetching device info: $e');
    }

    if (deviceId.isEmpty) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
    }

    if (fcmToken.isEmpty) {
      fcmToken = 'FALLBACK_FCM_TOKEN_12345';
    }

    await prefs.setString('device_id', deviceId);
    await prefs.setString('fcm_token', fcmToken);

    print('--- DEVICE DATA SAVED SUCCESSFULLY ---');
    print('Device ID: $deviceId');
    print('FCM Token: $fcmToken');
  }
}