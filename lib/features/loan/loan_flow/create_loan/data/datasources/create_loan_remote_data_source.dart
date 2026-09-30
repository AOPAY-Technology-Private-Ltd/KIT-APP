import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<bool> uploadDocuments({
    required String dob,
    required String? panNumber,
    required File? panPhoto,
    required String? aadhaarNumber,
    required File? frontImage,
    required File? backImage,
  });
}

class CreateLoanRemoteDataSourceImpl
    implements CreateLoanRemoteDataSource {
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

      print('=== PAN Verification Request ===');
      print('URL: $url');
      print('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      ).timeout(
        const Duration(seconds: 10),
      );

      print('=== PAN Verification Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data['Status']?.toString().toLowerCase() == 'true' ||
            data['result_code'] == 101;
      }

      return false;
    } catch (e) {
      print('=== PAN Verification Exception ===');
      print('Error: $e');

      throw Exception(
        'PAN Verification Error: $e',
      );
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
      (lastName == null || lastName.trim().isEmpty)
          ? 'Kumar'
          : lastName.trim();

      final resolvedMobile =
      (mobileNumber == null || mobileNumber.trim().isEmpty)
          ? '9999179728'
          : mobileNumber.trim();

      final resolvedEmail =
      (emailId == null || emailId.trim().isEmpty)
          ? 'naim@aopay.in'
          : emailId.trim();

      final requestBody = jsonEncode({
        'AadhaarNumber': aadhaarNumber,
        'FirstName': firstName,
        'LastName': resolvedLastName,
        'MobileNumber': resolvedMobile,
        'EmailID': resolvedEmail,
        'RegistrationID': 'AOP-554',
      });

      print('=== Aadhaar Validation Request ===');
      print('URL: $url');
      print('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      ).timeout(
        const Duration(seconds: 10),
      );

      print('=== Aadhaar Validation Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final kycUrl =
        data['model']?['kycUrl']?.toString();

        final transactionId =
        data['model']?['transactionId']?.toString();

        print('=== Aadhaar Validation Success ===');
        print('KYC URL: $kycUrl');
        print('Transaction ID: $transactionId');

        if (kycUrl != null && kycUrl.isNotEmpty) {
          Map<String, dynamic>? transactionResponse;


          if (transactionId != null &&
              transactionId.isNotEmpty) {
            print(
              '=== Calling Transaction API Immediately ===',
            );

            transactionResponse =
            await fetchAadhaarTransaction(
              transactionId,
            );

            print(
              '=== Immediate Transaction API Response ===',
            );

            print(transactionResponse);
          } else {
            print(
              'Transaction ID not received from Aadhaar API',
            );
          }

          return {
            'kycUrl': kycUrl,
            'transactionId': transactionId,
            'transactionResponse': transactionResponse,
          };
        }
      }

      return null;
    } catch (e) {
      print('=== Aadhaar Validation Exception ===');
      print('Error: $e');

      throw Exception(
        'Aadhaar Verification Error: $e',
      );
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

      print(
        '=== Fetch Aadhaar Transaction Request ===',
      );

      print('URL: $url');
      print('Body: $requestBody');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      ).timeout(
        const Duration(seconds: 10),
      );

      print(
        '=== Fetch Aadhaar Transaction Response ===',
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print(
        '=== Fetch Aadhaar Transaction Exception ===',
      );

      print('Error: $e');

      throw Exception(
        'Transaction Fetch Error: $e',
      );
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
  }) async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return true;
  }
}