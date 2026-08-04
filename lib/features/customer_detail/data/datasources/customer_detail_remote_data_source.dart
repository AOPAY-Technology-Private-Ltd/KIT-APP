import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer_detail_model.dart';

abstract class CustomerDetailRemoteDataSource {
  Future<CustomerDetailModel> getCustomerDetail(String customerIdentifier);
}

class CustomerDetailRemoteDataSourceImpl implements CustomerDetailRemoteDataSource {
  final http.Client client;
  final String apiUrl;

  CustomerDetailRemoteDataSourceImpl({
    required this.client,
    this.apiUrl = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/KitManageCustomer',
  });

  @override
  Future<CustomerDetailModel> getCustomerDetail(String customerIdentifier) async {
    final prefs = await SharedPreferences.getInstance();
    final retailerCode = prefs.getString('retailer_code') ?? 'AFD0031';

    final queryParams = <String, String>{
      'Mode': 'GET',
      'PrimaryMobileNumber': customerIdentifier,
      'RetailerCode': retailerCode,
    };

    final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);

    print('--- GET CUSTOMER DETAIL REQUEST ---');
    print('URL: $uri');

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'accept': '*/*',
    });

    request.fields['InvoiceFile'] = '';
    request.fields['refAdhaarNumberFrontPhoto_File'] = '';
    request.fields['CustAadharPhoto_File'] = '';
    request.fields['IMEINumber1_SealPhotoFile'] = '';
    request.fields['IMEINumber2_SealPhotoFile'] = '';
    request.fields['CustAadharBackPhoto_File'] = '';
    request.fields['refAdhaarNumberBackPhoto_File'] = '';
    request.fields['CustPanNumberPhoto_File'] = '';
    request.fields['CustPhoto_File'] = '';
    request.fields['refPanNumberPhoto_File'] = '';
    request.fields['IMEINumberPhotoFile'] = '';

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    print('--- GET CUSTOMER DETAIL RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);

      Map<String, dynamic> rawJson = {};

      if (decodedData is Map<String, dynamic>) {
        if (decodedData.containsKey('customerList') && decodedData['customerList'] is List) {
          final list = decodedData['customerList'] as List;
          rawJson = list.isNotEmpty ? list.first as Map<String, dynamic> : {};
        } else if (decodedData.containsKey('data') && decodedData['data'] is List) {
          final list = decodedData['data'] as List;
          rawJson = list.isNotEmpty ? list.first as Map<String, dynamic> : {};
        } else {
          rawJson = decodedData;
        }
      } else if (decodedData is List && decodedData.isNotEmpty) {
        rawJson = decodedData.first as Map<String, dynamic>;
      }

      return CustomerDetailModel.fromJson(rawJson);
    } else {
      throw Exception('Failed to load customer details: ${response.body}');
    }
  }
}