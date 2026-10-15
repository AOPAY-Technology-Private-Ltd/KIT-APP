import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/customer_detail_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerDetailModel> fetchCustomerDetail();
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final http.Client client;

  CustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<CustomerDetailModel> fetchCustomerDetail() async {
    const url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/GetRetailerCustomerLoanDetail';

    final String? retailerCode = await SessionManager.getRetailerCode();
    final String? customerCode = await SessionManager.getCustomerCodeTwo();
    final String? loanCode = await SessionManager.getLoanCode();

    final requestBody = {
      "retailerCode": retailerCode ?? "",
      "customerCode": customerCode ?? "",
      "loanCode": loanCode ?? "",
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

        final rawStatus = decodedData['status'];
        bool isSuccess = rawStatus is bool
            ? rawStatus
            : (rawStatus?.toString().toLowerCase() == 'true');

        if (isSuccess || decodedData['code'] == 200) {
          final dynamic dataField = decodedData['data'];
          Map<String, dynamic> customerJson = {};

          if (dataField is List && dataField.isNotEmpty) {
            customerJson = dataField[0] as Map<String, dynamic>;
          } else if (dataField is Map<String, dynamic>) {
            customerJson = dataField;
          }

          return CustomerDetailModel.fromJson(customerJson);
        } else {
          throw Exception(decodedData['message'] ?? 'Failed to load customer details');
        }
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