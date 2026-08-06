import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/invoice_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<InvoiceModel>> getMockInvoices();
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  @override
  Future<List<InvoiceModel>> getMockInvoices() async {
    final retailerCode = await SessionManager.getRetailerCode();

    final uri = Uri.parse(ApiConstants.getPurchaseHistory);
    final requestBody = {
      "companyCode": "CMP0005",
      "retailerCode": retailerCode ?? "",
    };

    print('--- API Request ---');
    print('URL: $uri');
    print('Body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('--- API Response ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true || decoded['data'] != null) {
        final List<dynamic> dataList = decoded['data'] ?? [];
        return dataList.map((json) => InvoiceModel.fromJson(json)).toList();
      } else {
        throw Exception(decoded['message'] ?? 'Failed to load purchase history');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}