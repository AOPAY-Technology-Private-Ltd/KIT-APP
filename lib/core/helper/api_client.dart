import 'package:http/http.dart' as http;

import '../network/network_service.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    bool isConnected = await NetworkService.hasInternet();
    if (!isConnected) {
      throw Exception('No internet connection. Please check your network settings.');
    }
    return await _client.get(url, headers: headers);
  }

  static Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body}) async {
    bool isConnected = await NetworkService.hasInternet();
    if (!isConnected) {
      throw Exception('No internet connection. Please check your network settings.');
    }
    return await _client.post(url, headers: headers, body: body);
  }
}