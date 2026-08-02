import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyRetailerCode = 'retailer_code';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyMobileNo = 'mobile_no';
  static const String _keyFirstName = 'first_name';

  static Future<void> createSession({
    required String retailerCode,
    required String mobileNo,
    String? firstName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRetailerCode, retailerCode);
    await prefs.setString(_keyMobileNo, mobileNo);
    if (firstName != null) {
      await prefs.setString(_keyFirstName, firstName);
    }
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getRetailerCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRetailerCode);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRetailerCode);
    await prefs.remove(_keyMobileNo);
    await prefs.remove(_keyFirstName);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}