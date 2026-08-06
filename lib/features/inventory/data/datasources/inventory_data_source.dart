import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/inventory_model.dart';

abstract class InventoryDataSource {
  Future<List<InventoryModel>> fetchInventoryData();
}

class InventoryRemoteDataSource implements InventoryDataSource {
  final http.Client client;

  InventoryRemoteDataSource({required this.client});

  @override
  Future<List<InventoryModel>> fetchInventoryData() async {
    final retailerCode = await SessionManager.getRetailerCode();
    if (retailerCode == null || retailerCode.isEmpty) {
      throw Exception('Retailer code not found in session.');
    }

    final url = ApiConstants.getKitInventory;
    final requestBody = jsonEncode({
      "retailerCode": retailerCode,
      "status": "ALL"
    });

    print('--- KIT INVENTORY API REQUEST ---');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('--- KIT INVENTORY API RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List<dynamic> kitList = decodedData['kitList'] ?? [];

      return kitList.map((json) => InventoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}