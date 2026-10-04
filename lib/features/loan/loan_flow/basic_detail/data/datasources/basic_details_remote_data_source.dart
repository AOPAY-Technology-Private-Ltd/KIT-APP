import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class BasicDetailsRemoteDataSource {
  Future<bool> verifyPan(String panNumber);
  Future<bool> verifyAadhaar(String aadhaarNumber);
  Future<bool> sendOtp({required String mobileOrEmailID, required String otpType});
  Future<String?> verifyOtp({required String mobileOrEmail, required String enteredOTP});
  Future<bool> uploadDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  });
  Future<bool> saveBasicDetails({
    required File? customerPhoto,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String? alternateNumber,
    required String? emailId,
    required String? address,
    required bool acceptTerms,
  });
}

class BasicDetailsRemoteDataSourceImpl implements BasicDetailsRemoteDataSource {
  final http.Client client;

  BasicDetailsRemoteDataSourceImpl({required this.client});

  @override
  Future<bool> verifyPan(String panNumber) async {
    return panNumber.length == 10;
  }

  @override
  Future<bool> verifyAadhaar(String aadhaarNumber) async {
    return aadhaarNumber.length == 12;
  }

  @override
  Future<bool> sendOtp({required String mobileOrEmailID, required String otpType}) async {
    try {
      final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/SendOTP');
      final requestBody = jsonEncode({
        'mobileOrEmailID': mobileOrEmailID,
        'otP_Type': otpType,
      });

      debugPrint('--- API REQUEST: SendOTP ---');
      debugPrint('URL: $url');
      debugPrint('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      debugPrint('--- API RESPONSE: SendOTP ---');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Send OTP Error: $e');
      throw Exception('Send OTP Error: $e');
    }
  }

  @override
  Future<String?> verifyOtp({required String mobileOrEmail, required String enteredOTP}) async {
    try {
      final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/VerifyOTP');
      final requestBody = jsonEncode({
        'mobileOrEmail': mobileOrEmail,
        'enteredOTP': enteredOTP,
      });

      debugPrint('--- API REQUEST: VerifyOTP ---');
      debugPrint('URL: $url');
      debugPrint('Outgoing Request Body to API: $requestBody');

      final response = await client.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      debugPrint('--- API RESPONSE: VerifyOTP ---');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['statuss']?.toString().toLowerCase();

        if (status == 'false' || status == '0') {
          return data['message'] ?? 'OTP verification failed.';
        }
        return null;
      } else {
        throw Exception('OTP verification failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Verify OTP Error: $e');
      throw Exception('Verify OTP Error: $e');
    }
  }

  @override
  Future<bool> uploadDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  }) async => true;

  @override
  Future<bool> saveBasicDetails({
    required File? customerPhoto,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String? alternateNumber,
    required String? emailId,
    required String? address,
    required bool acceptTerms,
  }) async {
    try {
      debugPrint('--- API REQUEST: SaveBasicDetails ---');
      debugPrint('First Name: $firstName, Last Name: $lastName, Mobile: $mobileNumber');

      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      debugPrint('Save Basic Details Error: $e');
      throw Exception('Save Basic Details Error: $e');
    }
  }
}