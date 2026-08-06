import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../core/services/session_manager.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> fetchHomeData();
  Future<List<CustomerModel>> fetchRecentCustomers({int? topRecords});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<HomeModel> fetchHomeData() async {
    String? retailerCode = await SessionManager.getRetailerCode();
    if (retailerCode == null || retailerCode.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 400));
      retailerCode = await SessionManager.getRetailerCode();
    }

    if (retailerCode == null || retailerCode.isEmpty) {
      throw Exception('Retailer code not found in session.');
    }

    const url = ApiConstants.fetchHomeData;
    final requestBody = jsonEncode({"retailerCode": retailerCode});

    final response = await client.post(
      Uri.parse(url),
      headers: {'accept': '*/*', 'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (decodedData['status'] == true || decodedData['data'] != null) {
        return HomeModel.fromJson(decodedData);
      } else {
        throw Exception(decodedData['message'] ?? 'Failed to fetch kit report');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  @override
  Future<List<CustomerModel>> fetchRecentCustomers({int? topRecords}) async {
    String? retailerCode = await SessionManager.getRetailerCode();
    if (retailerCode == null || retailerCode.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 400));
      retailerCode = await SessionManager.getRetailerCode();
    }

    if (retailerCode == null || retailerCode.isEmpty) {
      return [];
    }

    final queryParams = {
      'retailerCode': retailerCode,
      if (topRecords != null) 'topRecords': topRecords.toString(),
    };

    final uri = Uri.parse(ApiConstants.getRecentCustomers).replace(
      queryParameters: queryParams,
    );

    try {
      final response = await client.get(
        uri,
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['status'] == true || decodedData['data'] != null) {
          final dynamic rawData = decodedData['data'];

          if (rawData is List) {
            return rawData.map((json) => CustomerModel.fromJson(json as Map<String, dynamic>)).toList();
          }
        }
        return [];
      } else {
        print("Server returned status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching recent customers: $e");
      return [];
    }
  }
}