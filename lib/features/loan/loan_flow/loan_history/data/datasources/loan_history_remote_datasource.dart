import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/loan_portfolio_model.dart';

abstract class LoanHistoryRemoteDatasource {
  Future<LoanPortfolioModel> fetchLoanPortfolio({
    String searchText = "",
    String loanStatus = "",
    int pageNumber = 0,
    int pageSize = 0,
  });
}

class LoanHistoryRemoteDatasourceImpl implements LoanHistoryRemoteDatasource {
  final http.Client client;

  LoanHistoryRemoteDatasourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<LoanPortfolioModel> fetchLoanPortfolio({
    String searchText = "",
    String loanStatus = "",
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    const url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/GetLoanDisbursementHistory';

    final String clientCode = await SessionManager.getClientCode() ?? "CMP0005";
    final String retailerCode = await SessionManager.getRetailerCode() ?? "DL0032";

    final requestBody = {
      "ClientCode": clientCode,
      "RetailerCode": retailerCode,
      "SearchText": searchText,
      "LoanStatus": loanStatus,
      "PageNumber": pageNumber,
      "PageSize": pageSize,
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
        return LoanPortfolioModel.fromJson(decodedJson);
      } else {
        throw Exception(decodedJson['message'] ?? 'Failed to fetch loan history');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}