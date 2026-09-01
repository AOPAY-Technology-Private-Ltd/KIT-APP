import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/app_master_model.dart';
import '../models/customer_detail_model.dart';

abstract class CustomerDetailRemoteDataSource {
  Future<CustomerDetailModel> getCustomerDetail(String customerIdentifier);
  Future<AppMasterModel> getAppMaster();
  Future<bool> saveDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    List<Map<String, dynamic>>? selectedApps,
  });
  Future<bool> sendDeviceNotification({
    required String customerCode,
    required String notificationCode,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  });
  Future<bool> saveAndNotifyDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  });
}

class CustomerDetailRemoteDataSourceImpl implements CustomerDetailRemoteDataSource {
  final http.Client client;
  final String apiUrl;

  CustomerDetailRemoteDataSourceImpl({
    required this.client,
    this.apiUrl = ApiConstants.manageCustomer,
  });

  @override
  Future<CustomerDetailModel> getCustomerDetail(String customerIdentifier) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final retailerCode = prefs.getString('retailer_code') ?? await SessionManager.getRetailerCode() ?? '';

      final queryParams = <String, String>{
        'Mode': 'GET',
        'PrimaryMobileNumber': customerIdentifier,
        'RetailerCode': retailerCode,
      };

      final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({'accept': '*/*'});

      print('--- 🚀 GET CUSTOMER DETAIL REQUEST ---');
      print('URL: $uri');
      print('Method: POST (Multipart)');
      print('Headers: ${request.headers}');
      print('Query Parameters: $queryParams');

      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('No internet connection. Please check your network.');
        },
      );
      final response = await http.Response.fromStream(streamedResponse);

      print('--- 📥 GET CUSTOMER DETAIL RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          throw Exception('Server returned empty response body.');
        }

        final decodedData = jsonDecode(response.body);
        Map<String, dynamic> rawJson = {};

        if (decodedData is Map<String, dynamic>) {
          if (decodedData.containsKey('customerList') && decodedData['customerList'] is List) {
            final list = decodedData['customerList'] as List;
            rawJson = list.isNotEmpty ? list.first as Map<String, dynamic> : {};
          } else if (decodedData.containsKey('data') && decodedData['data'] is List) {
            final list = decodedData['data'] as List;
            rawJson = list.isNotEmpty ? list.first as Map<String, dynamic> : {};
          } else {
            rawJson = decodedData;
          }
        } else if (decodedData is List && decodedData.isNotEmpty) {
          rawJson = decodedData.first as Map<String, dynamic>;
        }

        if (rawJson.isEmpty) {
          throw Exception('Customer data not found in server response.');
        }

        return CustomerDetailModel.fromJson(rawJson);
      } else {
        throw Exception('Failed to load customer details [Status ${response.statusCode}]');
      }
    } catch (e) {
      print('--- ❌ GET CUSTOMER DETAIL ERROR ---');
      print('Error: $e');
      final errorStr = e.toString().replaceAll('Exception: ', '');
      if (errorStr.contains('SocketException') || errorStr.contains('ClientException')) {
        throw Exception('No internet connection. Please check your network.');
      }
      throw Exception(errorStr);
    }
  }

  @override
  Future<AppMasterModel> getAppMaster() async {
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';

      final queryParams = {'CreatedBy': retailerCode};
      final uri = Uri.parse(ApiConstants.getAppMaster).replace(
        queryParameters: queryParams,
      );

      print('--- 🚀 GET APP MASTER REQUEST ---');
      print('URL: $uri');
      print('Method: GET');
      print('Query Parameters: $queryParams');

      final response = await client.get(uri, headers: {'accept': '*/*'}).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('No internet connection.');
        },
      );

      print('--- 📥 GET APP MASTER RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) {
          return AppMasterModel(categories: []);
        }

        final decodedData = jsonDecode(response.body);
        if (decodedData is Map<String, dynamic>) {
          return AppMasterModel.fromJson(decodedData);
        } else {
          return AppMasterModel(categories: []);
        }
      } else {
        return AppMasterModel(categories: []);
      }
    } catch (e) {
      print('--- ❌ GET APP MASTER ERROR ---');
      print('Error: $e');
      return AppMasterModel(categories: []);
    }
  }

  @override
  Future<bool> saveDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    List<Map<String, dynamic>>? selectedApps,
  }) async {
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';
      final savedCustomerCode = await SessionManager.getCustomerCode() ?? customerCode;
      final clientCode = await SessionManager.getClientCode() ?? 'CMP0005';

      final uri = Uri.parse(ApiConstants.saveDeviceAction);

      final finalSelectedApps = (selectedApps == null || selectedApps.isEmpty)
          ? [{"packageName": notificationCode, "actionStatus": actionStatus}]
          : selectedApps;

      final requestBody = {
        "clientCode": clientCode,
        "retailerCode": retailerCode,
        "customerCode": savedCustomerCode,
        "notificationCode": notificationCode,
        "actionStatus": actionStatus,
        "selectedApps": finalSelectedApps,
        "createdBy": retailerCode,
      };

      print('--- 🚀 SAVE DEVICE ACTION REQUEST ---');
      print('URL: $uri');
      print('Method: POST');
      print('Headers: ${{'accept': '*/*', 'Content-Type': 'application/json'}}');
      print('Body: ${jsonEncode(requestBody)}');

      final response = await client.post(
        uri,
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('No internet connection. Please check your network.');
        },
      );

      print('--- 📥 SAVE DEVICE ACTION RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && (decoded['status'] == true || decoded['statusCode'] == 200)) {
          return true;
        }
        throw Exception(decoded['message'] ?? 'Failed to save device action');
      } else {
        throw Exception('Failed to save device action: ${response.body}');
      }
    } catch (e) {
      print('--- ❌ SAVE DEVICE ACTION ERROR ---');
      print('Error: $e');
      final errorStr = e.toString().replaceAll('Exception: ', '');
      if (errorStr.contains('SocketException') || errorStr.contains('ClientException')) {
        throw Exception('No internet connection. Please check your network.');
      }
      throw Exception(errorStr);
    }
  }

  @override
  Future<bool> sendDeviceNotification({
    required String customerCode,
    required String notificationCode,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  }) async {
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';
      final savedCustomerCode = await SessionManager.getCustomerCode() ?? customerCode;
      final clientCode = await SessionManager.getClientCode() ?? 'CMP0005';

      final uri = Uri.parse(ApiConstants.sendDeviceNotification);

      final finalSelectedApps = (selectedApps == null || selectedApps.isEmpty)
          ? [{"packageName": notificationCode, "actionStatus": true}]
          : selectedApps;

      final requestBody = {
        "clientCode": clientCode,
        "retailerCode": retailerCode,
        "customerCode": savedCustomerCode,
        "notificationCode": notificationCode,
        "title": "",
        "message": "",
        "devicePin": devicePin,
        "selectedApps": finalSelectedApps,
      };

      print('--- 🚀 SEND DEVICE NOTIFICATION REQUEST ---');
      print('URL: $uri');
      print('Method: POST');
      print('Headers: ${{'accept': '*/*', 'Content-Type': 'application/json'}}');
      print('Body: ${jsonEncode(requestBody)}');

      final response = await client.post(
        uri,
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('No internet connection. Please check your network.');
        },
      );

      print('--- 📥 SEND DEVICE NOTIFICATION RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && (decoded['status'] == true || decoded['statusCode'] == 200)) {
          return true;
        }
        return true;
      } else {
        throw Exception('Failed to send device notification: ${response.body}');
      }
    } catch (e) {
      print('--- ❌ SEND DEVICE NOTIFICATION ERROR ---');
      print('Error: $e');
      final errorStr = e.toString().replaceAll('Exception: ', '');
      if (errorStr.contains('SocketException') || errorStr.contains('ClientException')) {
        throw Exception('No internet connection. Please check your network.');
      }
      throw Exception(errorStr);
    }
  }

  @override
  Future<bool> saveAndNotifyDeviceAction({
    required String customerCode,
    required String notificationCode,
    required bool actionStatus,
    required String devicePin,
    List<Map<String, dynamic>>? selectedApps,
  }) async {
    final isSaved = await saveDeviceAction(
      customerCode: customerCode,
      notificationCode: notificationCode,
      actionStatus: actionStatus,
      selectedApps: selectedApps,
    );

    if (isSaved) {
      print('--- ⚡ SAVE API SUCCESS, NOW CALLING NOTIFICATION API ---');

      final isNotified = await sendDeviceNotification(
        customerCode: customerCode,
        notificationCode: notificationCode,
        devicePin: devicePin,
        selectedApps: selectedApps,
      );

      return isNotified;
    }

    return false;
  }

  Future<Map<String, dynamic>> getCustomerLatestLocationKit(String customerCode) async {
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';
      final savedCustomerCode = await SessionManager.getCustomerCode() ?? customerCode;
      final clientCode = await SessionManager.getClientCode() ?? 'CMP0005';

      final uri = Uri.parse(ApiConstants.getCustomerLatestLocationKit);

      final requestBody = {
        "clientCode": clientCode,
        "retailerCode": retailerCode,
        "customerCode": savedCustomerCode,
      };

      print('--- 🚀 GET CUSTOMER LATEST LOCATION KIT REQUEST ---');
      print('URL: $uri');
      print('Method: POST');
      print('Headers: ${{'accept': '*/*', 'Content-Type': 'application/json'}}');
      print('Body: ${jsonEncode(requestBody)}');

      final response = await client.post(
        uri,
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('No internet connection. Please check your network.');
        },
      );

      print('--- 📥 GET CUSTOMER LATEST LOCATION KIT RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      }
      return {};
    } catch (e) {
      print('--- ❌ GET CUSTOMER LATEST LOCATION KIT ERROR ---');
      print('Error: $e');
      return {};
    }
  }
}