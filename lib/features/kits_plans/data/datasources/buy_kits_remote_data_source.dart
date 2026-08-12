import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../../domain/entities/plan_entity.dart';
import '../models/payment_gateway_request_model.dart';
import '../models/plan_model.dart';
import '../models/save_purchase_history_request_model.dart';

abstract class BuyKitsRemoteDataSource {
  Future<List<PlanEntity>> fetchPlans();
  Future<List<PaymentMethodEntity>> fetchPaymentMethods();
  Future<Map<String, dynamic>> triggerPaymentGateway(PaymentGatewayRequestModel requestModel);

  Future<Map<String, dynamic>> savePurchaseHistory(SavePurchaseHistoryRequestModel requestModel);
}

class BuyKitsRemoteDataSourceImpl implements BuyKitsRemoteDataSource {
  final http.Client client;
  final String apiUrl;

  BuyKitsRemoteDataSourceImpl({
    required this.client,
    this.apiUrl = ApiConstants.fetchPlans,
  });

  @override
  Future<List<PlanEntity>> fetchPlans() async {
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';

      final uri = Uri.parse(apiUrl);

      print('--- GET RETAILER KIT PLANS REQUEST ---');
      print('URL: $uri');
      print('Request Body: {"companyCode": "CMP0005", "retailerCode": "$retailerCode"}');

      final response = await client.post(
        uri,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "companyCode": "CMP0005",
          "retailerCode": retailerCode,
        }),
      );

      print('--- GET RETAILER KIT PLANS RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);

        List<dynamic> rawList = [];
        if (decodedData is Map<String, dynamic>) {
          rawList = decodedData['data'] ?? [];
        } else if (decodedData is List) {
          rawList = decodedData;
        }

        return rawList
            .map((json) => PlanModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to load plans: ${response.body}");
      }
    } catch (e) {
      print('Error fetching plans: $e');
      throw Exception('Error fetching plans: $e');
    }
  }

  @override
  Future<List<PaymentMethodEntity>> fetchPaymentMethods() async {
    return PlanModel.getMockPaymentMethods();
  }

  @override
  Future<Map<String, dynamic>> triggerPaymentGateway(PaymentGatewayRequestModel requestModel) async {
    try {
      const String endpoint = "https://api.aopay.in/api/AOPay/Finance/LockKit/V1/PaymentGateway";
      final uri = Uri.parse(endpoint);

      print('--- PAYMENT GATEWAY REQUEST ---');
      print('URL: $uri');
      print('Body: ${jsonEncode(requestModel.toJson())}');

      final response = await client.post(
        uri,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestModel.toJson()),
      );

      print('--- PAYMENT GATEWAY RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to trigger payment gateway: ${response.body}");
      }
    } catch (e) {
      print('Error in payment gateway: $e');
      throw Exception('Error in payment gateway: $e');
    }
  }
  @override
  Future<Map<String, dynamic>> savePurchaseHistory(SavePurchaseHistoryRequestModel requestModel) async {
    const url = ApiConstants.savePurchaseHistory;


    final Map<String, dynamic> requestBodyMap = requestModel.toJson();


    print('--- SAVE PURCHASE HISTORY REQUEST ---');
    print('URL: $url');
    print('Body: ${jsonEncode(requestBodyMap)}');

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBodyMap),
      );

      print('--- SAVE PURCHASE HISTORY RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        return {'status': true, 'message': response.body};
      } else {
        throw Exception('Failed to save purchase history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in savePurchaseHistory: $e');
      rethrow;
    }
  }
}