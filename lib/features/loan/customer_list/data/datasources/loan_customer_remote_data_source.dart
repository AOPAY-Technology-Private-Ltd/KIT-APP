import 'dart:convert';
import 'dart:developer';
import '../../../../../core/services/session_manager.dart';
import 'package:http/http.dart' as http;
import '../models/loan_customer_model.dart';

abstract class LoanCustomerRemoteDataSource {
  Future<List<LoanCustomerModel>> fetchLoanCustomers(String status);
}

class LoanCustomerRemoteDataSourceImpl implements LoanCustomerRemoteDataSource {
  final http.Client client;

  LoanCustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<List<LoanCustomerModel>> fetchLoanCustomers(String status) async {
    const url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/GetCustomerByRetailerSummary';

    final String retailerCode = await SessionManager.getRetailerCode() ?? '';

    final requestBody = {
      "retailerCode": retailerCode,
      "searchText": ""
    };

    log('=== API REQUEST ===');
    log('URL: $url');
    log('Headers: {"Content-Type": "application/json", "accept": "*/*"}');
    log('Body: ${jsonEncode(requestBody)}');

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      log('=== API RESPONSE ===');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);

        final List<dynamic> listData = decodedData['data'] ?? decodedData['result'] ?? [];

        List<LoanCustomerModel> allCustomers = listData
            .map((json) => LoanCustomerModel.fromJson(json))
            .toList();

        if (status.toLowerCase() == 'active') {
          return allCustomers;
        } else {
          return allCustomers
              .where((customer) => customer.status.toLowerCase() == status.toLowerCase())
              .toList();
        }
      } else {
        throw Exception('Failed to load customers, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      log('=== API ERROR ===');
      log('Error: $e');
      rethrow;
    }
  }
}