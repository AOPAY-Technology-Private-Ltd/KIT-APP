import 'dart:convert';
import '../../../../../core/helper/api_client.dart';
import '../../../../../core/services/session_manager.dart';
import '../models/loan_home_model.dart';

abstract class LoanHomeRemoteDataSource {
  Future<LoanHomeModel> fetchHomeData();
}

class LoanHomeRemoteDataSourceImpl implements LoanHomeRemoteDataSource {
  LoanHomeRemoteDataSourceImpl();

  @override
  Future<LoanHomeModel> fetchHomeData() async {
    try {
      final String clientCode = await SessionManager.getClientCode() ?? "CMP0005";
      String? retailerCode = await SessionManager.getRetailerCode();

      if (retailerCode == null || retailerCode.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 400));
        retailerCode = await SessionManager.getRetailerCode();
      }

      if (retailerCode == null || retailerCode.isEmpty) {
        throw Exception('Retailer code not found in session.');
      }

      const urlString = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/GetRetailerDashboard';
      final url = Uri.parse(urlString);

      final requestBody = jsonEncode({
        "ClientCode": clientCode,
        "RetailerCode": retailerCode,
        "RecentCount": 0
      });

      print('--------------------------------------------------');
      print('🚀 API REQUEST: POST $urlString');
      print('📄 REQUEST BODY: $requestBody');
      print('--------------------------------------------------');

      final response = await ApiClient.post(
        url,
        headers: {'accept': '*/*', 'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 15));

      print('--------------------------------------------------');
      print('📥 API RESPONSE: STATUS [${response.statusCode}]');
      print('📄 RESPONSE BODY: ${response.body}');
      print('--------------------------------------------------');

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['code'] == 200 || decodedData['status'] == 'True' || decodedData['status'] == true) {
          return LoanHomeModel.fromJson(decodedData);
        } else {
          throw Exception(decodedData['message'] ?? 'Failed to fetch dashboard data');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchHomeData: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}