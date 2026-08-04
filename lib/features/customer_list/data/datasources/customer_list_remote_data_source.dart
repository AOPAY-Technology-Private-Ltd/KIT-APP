import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../models/customer_item_model.dart';

abstract class CustomerListRemoteDataSource {
  Future<List<CustomerItemModel>> getCustomerList();
}

class CustomerListRemoteDataSourceImpl implements CustomerListRemoteDataSource {
  final http.Client client;
  final bool useMockData;
  final String apiUrl;

  CustomerListRemoteDataSourceImpl({
    required this.client,
    this.useMockData = false,
    this.apiUrl = ApiConstants.getCustomerList,
  });

  @override
  Future<List<CustomerItemModel>> getCustomerList() async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));
      return [];
    } else {
      final prefs = await SharedPreferences.getInstance();
      final retailerCode = prefs.getString('retailer_code') ?? '';

      final queryParams = <String, String>{
        'Mode': 'GET',
        'RetailerCode': retailerCode,
      };

      final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

      print('--- GET CUSTOMER LIST REQUEST ---');
      print('URL: $uri');

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'accept': '*/*',
      });

      request.fields['CustPhoto_File'] = 'string';
      request.fields['IMEINumber1_SealPhotoFile'] = 'string';
      request.fields['IMEINumber2_SealPhotoFile'] = 'string';
      request.fields['InvoiceFile'] = 'string';
      request.fields['IMEINumberPhotoFile'] = 'string';
      request.fields['CustAadharPhoto_File'] = 'string';
      request.fields['CustAadharBackPhoto_File'] = 'string';
      request.fields['CustPanNumberPhoto_File'] = 'string';
      request.fields['refPanNumberPhoto_File'] = 'string';
      request.fields['refAdhaarNumberFrontPhoto_File'] = 'string';
      request.fields['refAdhaarNumberBackPhoto_File'] = 'string';

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print('--- GET CUSTOMER LIST RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);

        List<dynamic> rawList = [];
        if (decodedData is List) {
          rawList = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
          rawList = decodedData['data'] ??
              decodedData['result'] ??
              decodedData['customerList'] ?? [];
        }

        return rawList
            .map((json) => CustomerItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to load customer list: ${response.body}");
      }
    }
  }
}