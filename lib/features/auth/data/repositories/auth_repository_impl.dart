import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<AuthEntity> login({
    required String mobileOrEmailID,
    String password = "",
    String loginType = "Customer",
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String deviceId = prefs.getString('device_id') ?? '';
    final String token = prefs.getString('fcm_token') ?? 'sdsdsdssdsssds';

    final uri = Uri.parse(ApiConstants.kitRetailerLogin);

    final requestBody = {
      "mobileOrEmailID": mobileOrEmailID,
      "deviceId": deviceId,
      "token": token,
    };

    print('--- LOGIN REQUEST ---');
    print('URL: $uri');
    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('--- LOGIN RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      if (responseData['statuss'] == 'False' || responseData['statuss'] == false) {
        throw Exception(responseData['message'] ?? 'Login failed.');
      }

      return LoginResponseModel(
        message: responseData['message'] ?? "Login Successful",
      );
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }

  @override
  Future<AuthEntity> sendOtp(String mobileOrEmailID) async {
    return await datasource.sendOtp(mobileOrEmailID);
  }

  @override
  Future<AuthEntity> kitVerifyOtp({
    required String mobileOrEmail,
    required String otp,
  }) async {
    return await datasource.kitVerifyOtp(
      mobileOrEmail: mobileOrEmail,
      otp: otp,
    );
  }

  @override
  Future<AuthEntity> verifyOtp({
    required String mobileOrEmail,
    required String otp,
  }) async {
    return await datasource.verifyOtp(
      mobileOrEmail: mobileOrEmail,
      otp: otp,
    );
  }

  @override
  Future<AuthEntity> signup({
    required String businessName,
    required String businessType,
    String? gstNumber,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String emailID,
  }) async {
    final request = SignupRequestModel(
      businessName: businessName,
      businessType: businessType,
      gstNumber: gstNumber,
      firstName: firstName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      emailID: emailID,
    );

    return await datasource.signup(request);
  }
}