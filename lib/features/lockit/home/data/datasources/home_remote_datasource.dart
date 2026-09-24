import 'dart:convert';
import '../../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../../core/helper/api_client.dart';
import '../../../../../core/services/session_manager.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> fetchHomeData();
  Future<List<CustomerModel>> fetchRecentCustomers({int? topRecords});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl();

  @override
  Future<HomeModel> fetchHomeData() async {
    int maxAttempts = 2;
    int currentAttempt = 0;

    while (currentAttempt < maxAttempts) {
      currentAttempt++;
      try {
        String? retailerCode = await SessionManager.getRetailerCode();
        if (retailerCode == null || retailerCode.isEmpty) {
          await Future.delayed(const Duration(milliseconds: 400));
          retailerCode = await SessionManager.getRetailerCode();
        }

        if (retailerCode == null || retailerCode.isEmpty) {
          throw Exception('Retailer code not found in session.');
        }

        final url = Uri.parse(ApiConstants.fetchHomeData);
        final requestBody = jsonEncode({"retailerCode": retailerCode});

        print('--- FETCH HOME DATA REQUEST ---');
        print('URL: $url');
        print('Request Body: $requestBody');

        final response = await ApiClient.post(
          url,
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          body: requestBody,
        ).timeout(const Duration(seconds: 15));

        print('--- FETCH HOME DATA RESPONSE ---');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 500 && currentAttempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: 1));
          continue;
        }

        if (response.statusCode == 200) {
          final decodedData = jsonDecode(response.body);
          if (decodedData['status'] == true || decodedData['data'] != null) {
            return HomeModel.fromJson(decodedData);
          } else {
            throw Exception(decodedData['message'] ?? 'Failed to fetch home data');
          }
        } else {
          throw Exception('Server error: ${response.statusCode}');
        }
      } catch (e) {
        print('Error in fetchHomeData: $e');
        if (e.toString().contains('No internet connection')) {
          rethrow;
        }
        if (currentAttempt >= maxAttempts) {
          throw Exception(e.toString().replaceAll("Exception: ", ""));
        }
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw Exception('Failed to load home data');
  }
  @override
  Future<List<CustomerModel>> fetchRecentCustomers({int? topRecords}) async {
    try {
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

      final response = await ApiClient.get(
        uri,
        headers: {'accept': '*/*'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['status'] == true || decodedData['data'] != null) {
          final dynamic rawData = decodedData['data'];

          if (rawData is List) {
            return rawData
                .map((json) => CustomerModel.fromJson(json as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print("Error fetching recent customers: $e");
      return [];
    }
  }
}