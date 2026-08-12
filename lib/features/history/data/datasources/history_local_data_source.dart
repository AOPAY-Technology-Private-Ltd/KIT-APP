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
    try {
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
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("No internet connection. Please check your network.");
        },
      );

      print('--- API Response ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.trim().isEmpty) {
          return [];
        }

        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          if (decoded['status'] == false) {
            return [];
          }
          final List<dynamic> dataList = decoded['data'] ?? decoded['result'] ?? [];
          return dataList.map((json) => InvoiceModel.fromJson(json)).toList();
        } else if (decoded is List) {
          return decoded.map((json) => InvoiceModel.fromJson(json)).toList();
        }

        return [];
      } else {
        throw Exception('Server error (${response.statusCode}): Failed to load purchase history');
      }
    } catch (e) {
      print('--- HISTORY ERROR ---: $e');
      final errorStr = e.toString().replaceAll('Exception: ', '');
      if (errorStr.contains('SocketException') || errorStr.contains('ClientException')) {
        throw Exception("No internet connection. Please check your network.");
      }
      throw Exception(errorStr);
    }
  }
}