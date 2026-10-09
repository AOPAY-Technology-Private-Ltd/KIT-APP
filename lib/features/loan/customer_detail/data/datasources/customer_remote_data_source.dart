import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/customer_detail_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerDetailModel> fetchCustomerDetail({required String searchText});
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final http.Client client;

  CustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<CustomerDetailModel> fetchCustomerDetail({required String searchText}) async {
    const url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/RetailerSearchCustomer';

    final requestBody = {
      "searchText": searchText,
    };

    log('=== API REQUEST ===');
    log('URL: $url');
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

        // 'data' ek List hai, isliye pehle list check karke first element nikal rahe hain
        final dynamic dataField = decodedData['data'];
        Map<String, dynamic> customerJson = {};

        if (dataField is List && dataField.isNotEmpty) {
          customerJson = dataField[0] as Map<String, dynamic>;
        } else if (dataField is Map<String, dynamic>) {
          customerJson = dataField;
        }

        return CustomerDetailModel.fromJson(customerJson);
      } else {
        throw Exception('Failed to load customer details, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      log('=== API ERROR ===');
      log('Error: $e');
      rethrow;
    }
  }
}