import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyRetailerCode = 'retailer_code';
  static const String _keyCustomerCode = 'customer_code';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyMobileNo = 'mobile_no';
  static const String _keyFirstName = 'first_name';
  static const String _keyLastName = 'last_name';
  static const String _keyEmailID = 'email_id';
  static const String _keyClientCode = 'client_code';

  static Future<void> createSession({
    required String retailerCode,
    String? customerCode,
    required String mobileNo,
    required String emailID,
    String? firstName,
    String? lastName,
    String? clientCode,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRetailerCode, retailerCode);

    if (customerCode != null && customerCode.isNotEmpty) {
      await prefs.setString(_keyCustomerCode, customerCode);
    }

    await prefs.setString(_keyMobileNo, mobileNo);
    await prefs.setString(_keyEmailID, emailID);

    if (firstName != null) {
      await prefs.setString(_keyFirstName, firstName);
    }
    if (lastName != null) {
      await prefs.setString(_keyLastName, lastName);
    }
    if (clientCode != null) {
      await prefs.setString(_keyClientCode, clientCode);
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

  static Future<String?> getCustomerCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCustomerCode);
  }

  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName);
  }

  static Future<String?> getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastName);
  }

  static Future<String?> getMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMobileNo);
  }

  static Future<String?> getEmailID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmailID);
  }

  static Future<String?> getClientCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyClientCode);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRetailerCode);
    await prefs.remove(_keyCustomerCode);
    await prefs.remove(_keyMobileNo);
    await prefs.remove(_keyFirstName);
    await prefs.remove(_keyLastName);
    await prefs.remove(_keyEmailID);
    await prefs.remove(_keyClientCode);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}