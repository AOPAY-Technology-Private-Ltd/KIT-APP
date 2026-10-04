import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../../../core/services/session_manager.dart';

abstract class CreateLoanRemoteDataSource {
  Future<bool> verifyPan(String panNumber);

  Future<Map<String, dynamic>?> verifyAadhaar(
      String aadhaarNumber, {
        required String firstName,
        String? lastName,
        String? mobileNumber,
        String? emailId,
      });

  Future<Map<String, dynamic>?> fetchAadhaarTransaction(
      String transactionId);

  Future<String?> checkLoanReapplyEligibility({
    required String panNumber,
    required String aadhaarNumber,
  });

  Future<Map<String, dynamic>?> getCreditReport({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String dateOfBirth,
    required String emailId,
    required String panNumber,
    required String otp,
    required String consentMessage,
    required String consentAcceptance,
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

  Future<String?> uploadDocuments({
    required File? customerPhoto,
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
    required String firstName,
    String? lastName,
    String? mobileNumber,
    String? emailId,
    String? primaryOtp,
    bool isPanVerified = false,
    bool isAadhaarVerified = false,
    String? cibilScore,
    String? address,
    String? pinCode,
    String? stateName,
    String? cityName,
  });
}

class CreateLoanRemoteDataSourceImpl implements CreateLoanRemoteDataSource {
  final http.Client client;

  CreateLoanRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<bool> verifyPan(String panNumber) async {
    try {
      final url = Uri.parse(
        'https://api.aopay.in/api/AOP/V1/Validation/PanDetails',
      );

      final requestBody = jsonEncode({
        'PanNumber': panNumber,
        'RegistrationID': 'AOP-554',
      });

      debugPrint('=== API REQUEST: verifyPan ===');
      debugPrint('URL: $url');
      debugPrint('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 10));

      debugPrint('=== API RESPONSE: verifyPan ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] ?? data['Status'];
        return status == true ||
            status.toString().toLowerCase() == 'true' ||
            data['result_code'] == 101;
      }
      return false;
    } catch (e) {
      debugPrint('=== PAN Verification Exception: $e ===');
      throw Exception('PAN Verification Error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> verifyAadhaar(
      String aadhaarNumber, {
        required String firstName,
        String? lastName,
        String? mobileNumber,
        String? emailId,
      }) async {
    try {
      final url = Uri.parse(
        'https://api.aopay.in/api/AOP/V1/Validation/AadhaarValidateUrl',
      );

      final resolvedLastName =
      (lastName == null || lastName.trim().isEmpty) ? '' : lastName.trim();

      final resolvedMobile = mobileNumber?.trim() ?? '';
      final resolvedEmail = emailId?.trim().isNotEmpty == true
          ? emailId!.trim()
          : 'testuser@gmail.com';

      final requestBody = jsonEncode({
        'FirstName': firstName,
        'LastName': resolvedLastName,
        'MobileNumber': resolvedMobile,
        'EmailID': resolvedEmail,
        'RegistrationID': 'AOP-554',
      });

      debugPrint('=== API REQUEST: verifyAadhaar ===');
      debugPrint('URL: $url');
      debugPrint('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 10));

      debugPrint('=== API RESPONSE: verifyAadhaar ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final kycUrl = data['model']?['kycUrl']?.toString();
        final transactionId = data['model']?['transactionId']?.toString();

        if (kycUrl != null && kycUrl.isNotEmpty) {
          return {
            'kycUrl': kycUrl,
            'transactionId': transactionId,
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint('=== Aadhaar Validation Exception: $e ===');
      throw Exception('Aadhaar Verification Error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchAadhaarTransaction(
      String transactionId) async {
    try {
      final url = Uri.parse(
        'https://api.aopay.in/api/AOP/V1/Fetch/Digilocker/TransactionID',
      );

      final requestBody = jsonEncode({
        'TransactionID': transactionId,
        'RegistrationID': 'AOP-554',
      });

      debugPrint('=== API REQUEST: fetchAadhaarTransaction ===');
      debugPrint('URL: $url');
      debugPrint('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 10));

      debugPrint('=== API RESPONSE: fetchAadhaarTransaction ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('=== Fetch Aadhaar Transaction Exception: $e ===');
      throw Exception('Transaction Fetch Error: $e');
    }
  }

  @override
  Future<String?> checkLoanReapplyEligibility({
    required String panNumber,
    required String aadhaarNumber,
  }) async {
    try {
      final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/IsLoanReapplyEligible');

      final requestBody = jsonEncode({
        'PanNumber': panNumber,
        'AadharNumber': aadhaarNumber,
      });

      debugPrint('=== API REQUEST: checkLoanReapplyEligibility ===');
      debugPrint('URL: $url');
      debugPrint('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 10));

      debugPrint('=== API RESPONSE: checkLoanReapplyEligibility ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']?.toString() ?? data['Message']?.toString();
      }
      return null;
    } catch (e) {
      debugPrint('=== CheckLoanReapplyEligibility Exception: $e ===');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCreditReport({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String dateOfBirth,
    required String emailId,
    required String panNumber,
    required String otp,
    required String consentMessage,
    required String consentAcceptance,
  }) async {
    try {
      final url = Uri.parse('https://api.aopay.in/api/AOP/CreditAnalytics/Report');

      final requestBody = jsonEncode({
        'FirstName': firstName,
        'LastName': lastName,
        'MobileNumber': mobileNumber,
        'DateOfBirth': dateOfBirth,
        'EmailID': emailId,
        'PanNumber': panNumber,
        'OTP': otp,
        'ConsentMessage': consentMessage,
        'ConsentAcceptance': "yes",
        'RegistrationID': 'AOP-554',
      });

      debugPrint('=== API REQUEST: getCreditReport ===');
      debugPrint('URL: $url');
      debugPrint('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 15));

      debugPrint('=== API RESPONSE: getCreditReport ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('=== GetCreditReport Exception: $e ===');
      throw Exception('Credit Report Error: $e');
    }
  }

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
      debugPrint('=== API REQUEST: saveBasicDetails ===');
      debugPrint('Name: $firstName $lastName | Mobile: $mobileNumber | Address: $address');
      return true;
    } catch (e) {
      debugPrint('SaveBasicDetails Error: $e');
    }
    return false;
  }

  @override
  Future<String?> uploadDocuments({
    required File? customerPhoto,
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
    required String firstName,
    String? lastName,
    String? mobileNumber,
    String? emailId,
    String? primaryOtp,
    bool isPanVerified = false,
    bool isAadhaarVerified = false,
    String? cibilScore,
    String? address,
    String? pinCode,
    String? stateName,
    String? cityName,
  }) async {
    try {
      final savedRetailerCode = await SessionManager.getRetailerCode() ?? 'DL0032';
      final savedClientCode = await SessionManager.getClientCode() ?? 'CMP0005';

      String formattedDob = dob;
      try {
        final parsedDate = DateTime.parse(dob);
        formattedDob = DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (_) {}

      final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/ManageCustomerStepWise');
      var request = http.MultipartRequest('POST', url);

      request.fields['Mode'] = 'INSERT';
      request.fields['Step'] = '1';
      request.fields['FirstName'] = firstName;
      request.fields['MiddleName'] = '';
      request.fields['LastName'] = lastName ?? '';
      request.fields['DOB'] = formattedDob;
      request.fields['PrimaryMobileNumber'] = mobileNumber ?? '';
      request.fields['PrimaryOTP'] = primaryOtp ?? '';
      request.fields['PrimaryMobileVerified'] = 'Yes';
      request.fields['AlternateMobileNumber'] = '';
      request.fields['AlternateMobileOTP'] = '';
      request.fields['PAlternateMobileVerified'] = 'No';
      request.fields['EMailID'] = emailId?.isNotEmpty == true ? emailId! : 'testcustomer@gmail.com';

      request.fields['FlatNo'] = '';
      request.fields['AearSector'] = '';
      request.fields['CurrentAddress'] = address ?? '';
      request.fields['PinCode'] = pinCode ?? '';
      request.fields['Country'] = 'India';
      request.fields['StateName'] = stateName ?? '';
      request.fields['CityName'] = cityName ?? '';

      request.fields['AadharNumber'] = aadhaarNumber ?? '';
      request.fields['AadharNumberVerified'] = isAadhaarVerified ? 'Yes' : 'No';
      request.fields['PANNumber'] = panNumber ?? '';
      request.fields['PANNumberVerified'] = isPanVerified ? 'Yes' : 'No';

      request.fields['CibilScore'] = cibilScore ?? '750';
      request.fields['CreatedBy'] = 'Admin';

      request.fields['RetailerCode'] = savedRetailerCode;
      request.fields['clientcode'] = savedClientCode;

      if (customerPhoto != null && await customerPhoto.exists()) {
        request.files.add(await http.MultipartFile.fromPath('CustPhoto_path', customerPhoto.path));
      }
      if (panPhoto != null && await panPhoto.exists()) {
        request.files.add(await http.MultipartFile.fromPath('CustPanNumberPhoto_Path', panPhoto.path));
      }
      if (frontImage != null && await frontImage.exists()) {
        request.files.add(await http.MultipartFile.fromPath('CustAdhaarPhoto_path', frontImage.path));
      }
      if (backImage != null && await backImage.exists()) {
        request.files.add(await http.MultipartFile.fromPath('CustAadharBackPhoto_Path', backImage.path));
      }

      debugPrint('=== API REQUEST: ManageCustomerStepWise ===');
      debugPrint('URL: $url');
      debugPrint('Fields: ${request.fields}');
      debugPrint('Files Count: ${request.files.length}');

      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('=== API RESPONSE: ManageCustomerStepWise ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['success'] ?? data['Status'] ?? data['statuss'];
        final isSuccess = status == true || status.toString().toLowerCase() == 'true';

        if (isSuccess) {
          // Response se customerCode extract karke session me save karwa rahe hain
          final responseData = data['data'];
          if (responseData != null && responseData['customerCode'] != null) {
            final String extractedCustomerCode = responseData['customerCode'].toString();
            await SessionManager.saveCustomerCodes(extractedCustomerCode);
            debugPrint('=== Saved CustomerCode to Session: $extractedCustomerCode ===');
          }

          return null;
        } else {
          return data['message']?.toString() ?? 'Something went wrong';
        }
      }
      return 'Server error with status code: ${response.statusCode}';
    } catch (e) {
      debugPrint('=== ManageCustomerStepWise Exception: $e ===');
      return 'Exception: $e';
    }
  }
}