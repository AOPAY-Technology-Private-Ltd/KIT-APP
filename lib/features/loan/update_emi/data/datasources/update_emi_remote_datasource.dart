import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/update_emi_request_model.dart';

abstract class UpdateEmiRemoteDataSource {
  Future<EmiPaymentDetailModel> fetchEmiPaymentDetails();
  Future<bool> submitEmiUpdate(Map<String, dynamic> payload);
}

class UpdateEmiRemoteDataSourceImpl implements UpdateEmiRemoteDataSource {
  final http.Client client;

  UpdateEmiRemoteDataSourceImpl({required this.client});

  @override
  Future<EmiPaymentDetailModel> fetchEmiPaymentDetails() async {
    const String url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/GetRetailerEMIPaymentDetails';

    final String? retailerCode = await SessionManager.getRetailerCode();
    final String? customerCode = await SessionManager.getCustomerCodeTwo();
    final String? loanCode = await SessionManager.getLoanCode();

    final Map<String, dynamic> requestBody = {
      "retailerCode": retailerCode ?? "",
      "customerCode": customerCode ?? "",
      "loanCode": loanCode ?? "",
    };

    log('=== FETCH EMI DETAILS REQUEST ===');
    log('URL: $url');
    log('Request Body: ${jsonEncode(requestBody)}');

    final response = await client.post(
      Uri.parse(url),
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    log('=== FETCH EMI DETAILS RESPONSE ===');
    log('Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final rawStatus = decodedData['success'] ?? decodedData['status'];
      bool isSuccess = rawStatus == true || rawStatus.toString().toLowerCase() == 'true';

      if (isSuccess || decodedData['code'] == 200) {
        final data = decodedData['data'];
        return EmiPaymentDetailModel.fromJson(data is List ? data[0] : data);
      } else {
        throw Exception(decodedData['message'] ?? 'Failed to load EMI details');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  @override
  Future<bool> submitEmiUpdate(Map<String, dynamic> payload) async {
    const String url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/RetailerConfirmAndMarkPaid';

    final String? retailerCode = await SessionManager.getRetailerCode();
    final String? customerCode = await SessionManager.getCustomerCodeTwo();
    final String? loanCode = await SessionManager.getLoanCode();

    List<int> selectedEmiNumbers = [];
    if (payload['selectedEmiNumbers'] is List && (payload['selectedEmiNumbers'] as List).isNotEmpty) {
      selectedEmiNumbers = (payload['selectedEmiNumbers'] as List)
          .map((e) => int.tryParse(e.toString()) ?? 1)
          .toList();
    } else {
      int count = int.tryParse(payload['number_of_emi']?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '1') ?? 1;
      selectedEmiNumbers = List.generate(count, (index) => index + 1);
    }

    final String paymentReference = (payload['transaction_id'] ?? '').toString().trim();
    final String paymentMode = (payload['payment_mode'] ?? 'Cash').toString();

    final Map<String, dynamic> requestBody = {
      "retailerCode": retailerCode ?? "",
      "customerCode": customerCode ?? "",
      "loanCode": loanCode ?? "",
      "paymentMode": paymentMode,
      "paymentReference": paymentReference,
      "remarks": "Customer Paid By $paymentMode",
      "selectedEmiNumbers": selectedEmiNumbers,
    };

    log('=== SUBMIT EMI UPDATE REQUEST ===');
    log('URL: $url');
    log('Request Body: ${jsonEncode(requestBody)}');

    final response = await client.post(
      Uri.parse(url),
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    log('=== SUBMIT EMI UPDATE RESPONSE ===');
    log('Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final rawStatus = decodedData['success'] ?? decodedData['status'];
      bool isSuccess = rawStatus == true || rawStatus.toString().toLowerCase() == 'true';

      if (isSuccess || decodedData['code'] == 200) {
        return true;
      } else {
        throw Exception(decodedData['message'] ?? 'Failed to update EMI');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}