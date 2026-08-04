import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> fetchHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<HomeModel> fetchHomeData() async {
    final retailerCode = await SessionManager.getRetailerCode();

    if (retailerCode == null || retailerCode.isEmpty) {
      throw Exception('Retailer code not found in session.');
    }

    const url = ApiConstants.fetchHomeData;

    final requestBody = jsonEncode({
      "retailerCode": retailerCode,
    });

    print('----------------- HOME API REQUEST -----------------');
    print('URL: $url');
    print('Headers: {"accept": "*/*", "Content-Type": "application/json"}');
    print('Body: $requestBody');
    print('----------------------------------------------------');

    final response = await client.post(
      Uri.parse(url),
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('----------------- HOME API RESPONSE -----------------');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('-----------------------------------------------------');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData['status'] == true) {
        return HomeModel.fromJson(decodedData);
      } else {
        throw Exception(decodedData['message'] ?? 'Failed to fetch kit report');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}