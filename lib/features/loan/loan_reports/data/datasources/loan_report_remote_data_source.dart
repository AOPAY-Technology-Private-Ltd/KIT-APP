import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/loan_report_model.dart';

abstract class LoanReportRemoteDataSource {
  Future<Map<String, dynamic>> fetchReports(String status);
}

class LoanReportRemoteDataSourceImpl implements LoanReportRemoteDataSource {
  final http.Client client;

  LoanReportRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<Map<String, dynamic>> fetchReports(String status) async {
    const url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/GetLoanReports';

    final String clientCode = await SessionManager.getClientCode() ?? "";
    final String retailerCode = await SessionManager.getRetailerCode() ?? "";

    final requestBody = {
      "ClientCode": clientCode,
      "RetailerCode": retailerCode,
      "SearchText": "",
      "LoanStatus": status,
      "PageNumber": 0,
      "PageSize": 0
    };

    print('--------------------------------------------------');
    print('🚀 API REQUEST: POST $url');
    print('📦 REQUEST HEADERS: {accept: */*, Content-Type: application/json}');
    print('📄 REQUEST BODY: ${jsonEncode(requestBody)}');
    print('--------------------------------------------------');

    final response = await client.post(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('--------------------------------------------------');
    print('📥 API RESPONSE: STATUS [${response.statusCode}]');
    print('📄 RESPONSE BODY: ${response.body}');
    print('--------------------------------------------------');

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);

      if (decodedJson['code'] == 200 || decodedJson['status'] == 'True' || decodedJson['status'] == true) {
        final data = decodedJson['data'] ?? {};

        final double totalVolume = (data['totalVolume'] as num?)?.toDouble() ?? 0.0;
        final int totalLoans = data['totalLoans'] ?? 0;

        final List<dynamic> loanListJson = data['loanList'] ?? [];
        final List<LoanReportModel> models = loanListJson
            .map((json) => LoanReportModel.fromJson(json))
            .toList();

        return {
          'totalCount': totalLoans,
          'totalVolume': totalVolume,
          'loans': models,
        };
      } else {
        throw Exception(decodedJson['message'] ?? 'Failed to fetch loan reports');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}