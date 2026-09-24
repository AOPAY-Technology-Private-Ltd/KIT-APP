import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../../core/helper/api_client.dart';
import '../../../../../core/services/session_manager.dart';
import '../../domain/entities/entities.dart';
import '../models/login_response_model.dart';
import '../models/signup_request_model.dart';
import '../models/verify_otp_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

abstract class AuthRemoteDatasource {

  Future<LoginResponseModel> login({
    required String mobileOrEmailID,
  });

  Future<LoginResponseModel> sendOtp(String mobileOrEmailID);
  Future<AuthEntity> verifyOtp({
    required String mobileOrEmail,
    required String otp,
  });
  Future<LoginResponseModel> signup(SignupRequestModel request);
  Future<void> sendSmsForVerifyMob({
    required String mobnumber,
    required String customerName,
    required String otp,
  });

  Future<LoginResponseModel> kitVerifyOtp({
    required String mobileOrEmail,
    required String otp,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {

  bool _isSendingOtp = false;

  @override
  Future<LoginResponseModel> sendOtp(String mobileOrEmailID) async {
    if (_isSendingOtp) {
      return LoginResponseModel(message: "OTP already sending...");
    }
    _isSendingOtp = true;

    try {
      final uri = Uri.parse(ApiConstants.sendOtp);

      final requestBody = {
        "mobileOrEmailID": mobileOrEmailID,
        "otP_Type": "Retailer",
      };

      print('--- SEND OTP REQUEST ---');
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

      print('--- SEND OTP RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        final String backendOtp = responseData['value']?.toString() ?? "1234";

        if (mobileOrEmailID.length == 10) {
          await sendSmsForVerifyMob(
            mobnumber: mobileOrEmailID,
            customerName: "User",
            otp: backendOtp,
          );
        }

        return LoginResponseModel(
          message: responseData['message'] ?? "OTP Sent Successfully",
        );
      } else {
        throw Exception("Failed to send OTP: ${response.body}");
      }
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      _isSendingOtp = false;
    }
  }
  @override
  Future<LoginResponseModel> login({
    required String mobileOrEmailID,
  }) async {
    final uri = Uri.parse(ApiConstants.kitRetailerLogin);

    final prefs = await SharedPreferences.getInstance();

    String deviceId = prefs.getString('device_id') ?? '';

    if (deviceId.isEmpty) {
      try {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceId = androidInfo.id;
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? '';
        }
      } catch (e) {
        print("Error fetching Device ID on the fly: $e");
      }
    }

    if (deviceId.isEmpty) {
      deviceId = "DEVICE_ID_UNAVAILABLE";
    }

    final String token = prefs.getString('fcm_token') ?? '';
    final requestBody = {
      "mobileOrEmailID": mobileOrEmailID,
      "deviceId": deviceId,
      "token": token,
    };

    print('--- LOGIN REQUEST ---');
    print('URL: $uri');
    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await ApiClient.post(
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

      if (responseData['statuss'] == 'False' ||
          responseData['statuss'] == false) {
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
  Future<LoginResponseModel> verifyOtp({
    required String mobileOrEmail,
    required String otp,
  }) async {
    final uri = Uri.parse(ApiConstants.verifyOtp);

    final requestModel = VerifyOtpRequestModel(
      mobileOrEmail: mobileOrEmail,
      enteredOTP: otp,
    );

    print('--- VERIFY OTP REQUEST (SIGNUP) ---');
    print('URL: $uri');
    print('Request Body: ${jsonEncode(requestModel.toJson())}');

    final response = await ApiClient.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestModel.toJson()),
    );

    print('--- VERIFY OTP RESPONSE (SIGNUP) ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      if (responseData['statuss'] == 'False' ||
          responseData['statuss'] == false) {
        throw Exception(responseData['message'] ?? 'Incorrect OTP.');
      }

      return LoginResponseModel(
        message: responseData['message'] ?? "OTP Verified Successfully",
      );
    } else {
      throw Exception("Failed to verify OTP: ${response.body}");
    }
  }


  @override
  Future<void> sendSmsForVerifyMob({
    required String mobnumber,
    required String customerName,
    required String otp,
  }) async {
    final message = "Dear $customerName, Your OTP for Verification is $otp. Please Do Not Share the OTP With Anyone. Thanks For Using BOSOQ BOS CENTER";

    final uri = Uri.parse(ApiConstants.sendSms).replace(
      queryParameters: {
        'apikey': ConstantClass.smsApiKey,
        'senderid': ConstantClass.smsSenderId,
        'templateid': ConstantClass.smsTemplateId,
        'number': mobnumber,
        'message': message,
      },
    );

    print('--- SEND SMS API REQUEST ---');
    print('URL: $uri');

    final response = await ApiClient.get(uri);

    print('--- SEND SMS API RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception("Failed to send SMS: ${response.body}");
    }
  }

  @override
  Future<LoginResponseModel> kitVerifyOtp({
    required String mobileOrEmail,
    required String otp,
  }) async {
    final uri = Uri.parse(ApiConstants.kitVerifyOtp);

    final requestBody = {
      "mobileOrEmail": mobileOrEmail,
      "enteredOTP": otp,
    };

    print('--- KIT VERIFY OTP REQUEST ---');
    print('URL: $uri');
    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await ApiClient.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('--- KIT VERIFY OTP RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      if (responseData['status'] == false ||
          responseData['status'] == 'False' ||
          responseData['statuss'] == 'False' ||
          responseData['statuss'] == false) {
        throw Exception(responseData['message'] ?? 'OTP verification failed.');
      }

      final loginResponse = LoginResponseModel.fromJson(responseData);

      final extractedClientCode = loginResponse.clientCode ??
          responseData['clientcode']?.toString() ??
          responseData['clientCode']?.toString();

      if ((loginResponse.retailerCode != null && loginResponse.retailerCode!.isNotEmpty) ||
          (responseData['customerCode'] != null && responseData['customerCode'].toString().isNotEmpty)) {

        await SessionManager.createSession(
          retailerCode: loginResponse.retailerCode ?? responseData['customerCode'].toString(),
          customerCode: responseData['customerCode']?.toString(),
          mobileNo: loginResponse.mobileNo ?? mobileOrEmail,
          emailID: loginResponse.emailID ?? '',
          firstName: loginResponse.firstName,
          lastName: loginResponse.lastName,
          clientCode: extractedClientCode,
        );
      }

      return loginResponse;
    } else {
      throw Exception("Failed to verify OTP: ${response.body}");
    }
  }


  @override
  Future<LoginResponseModel> signup(SignupRequestModel request) async {
    final uri = Uri.parse(ApiConstants.signup);

    final requestMultipart = http.MultipartRequest(
      'POST',
      uri,
    );

    requestMultipart.fields.addAll({
      'BussinessName': request.businessName,
      'BussinessType': request.businessType,
      'GSTNumber': request.gstNumber ?? '',
      'FirstName': request.firstName,
      'LastName': request.firstName,
      'MobileNumber': request.mobileNumber,
      'EmailID': request.emailID,
      'Profile_Photo_FileName': '',
      'Adhaar_front_photo_FileName': '',
      'Adhaar_back_Photo_FileName': '',
      'PanCard_fornt_Photo_FileName': '',
      'cancle_cheque_Photo_FileName': '',
      'store_front_Photo_FileName': '',
      'company_doc_Photo_FileName': '',
    });

    Future<void> addFileIfNotNull(String fieldName, String? filePath) async {
      if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          requestMultipart.files.add(
            await http.MultipartFile.fromPath(
              fieldName,
              filePath,
            ),
          );
        }
      }
    }

    await addFileIfNotNull(
        'Profile_Photo_FileName', request.profilePhotoFileName);
    await addFileIfNotNull(
        'Adhaar_front_photo_FileName', request.adhaarFrontPhotoFileName);
    await addFileIfNotNull(
        'Adhaar_back_Photo_FileName', request.adhaarBackPhotoFileName);
    await addFileIfNotNull(
        'PanCard_fornt_Photo_FileName', request.panCardFrontPhotoFileName);
    await addFileIfNotNull(
        'cancle_cheque_Photo_FileName', request.cancleChequePhotoFileName);
    await addFileIfNotNull(
        'store_front_Photo_FileName', request.storefrontPhotoFileName);
    await addFileIfNotNull(
        'company_doc_Photo_FileName', request.companyDocPhotoFileName);

    print("----- SIGNUP REQUEST -----");
    print(requestMultipart.fields);

    final streamedResponse = await requestMultipart.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("----- SIGNUP RESPONSE -----");
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);

      final statusValue = body['statuss']?.toString().toLowerCase() ?? "";
      final customerCode = body['customerCode'];
      final message = body['message'] ?? "Signup failed";

      final bool isFailedStatus = statusValue == "false" ||
          (statusValue != "200" && statusValue != "true" &&
              statusValue.isNotEmpty);

      if (isFailedStatus || customerCode == null || customerCode
          .toString()
          .isEmpty) {
        throw Exception(message);
      }

      final mobileNumber = body['mobileNumber'] ?? request.mobileNumber;
      final firstName = body['firstName'] ?? request.firstName;
      final emailID = body['emailID'] ?? request.emailID;

      await SessionManager.createSession(
        retailerCode: customerCode.toString(),
        mobileNo: mobileNumber,
        emailID: emailID,
        firstName: firstName,
      );

      return LoginResponseModel(
        message: message,
      );
    } else {
      throw Exception("Server Error ${response.statusCode}: ${response.body}");
    }
  }
}

class ConstantClass {
  static const String smsApiKey = "KBSxc26XqjoiR7SA";
  static const String smsSenderId = "BOSCNT";
  static const String smsTemplateId = "1207175396979758678";
}