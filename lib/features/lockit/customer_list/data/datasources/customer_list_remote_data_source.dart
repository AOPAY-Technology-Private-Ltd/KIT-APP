import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/constants/apiconstants/api_constants.dart';
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
      try {
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

        request.fields['CustPhoto_File'] = '';
        request.fields['IMEINumber1_SealPhotoFile'] = '';
        request.fields['IMEINumber2_SealPhotoFile'] = '';
        request.fields['InvoiceFile'] = '';
        request.fields['IMEINumberPhotoFile'] = '';
        request.fields['CustAadharPhoto_File'] = '';
        request.fields['CustAadharBackPhoto_File'] = '';
        request.fields['CustPanNumberPhoto_File'] = '';
        request.fields['refPanNumberPhoto_File'] = '';
        request.fields['refAdhaarNumberFrontPhoto_File'] = '';
        request.fields['refAdhaarNumberBackPhoto_File'] = '';

        final streamedResponse = await client.send(request).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception("No internet connection. Please check your network.");
          },
        );

        final response = await http.Response.fromStream(streamedResponse);

        print('--- GET CUSTOMER LIST RESPONSE ---');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.body.trim().isEmpty) {
            return [];
          }

          final decodedData = jsonDecode(response.body);

          List<dynamic> rawList = [];
          if (decodedData is List) {
            rawList = decodedData;
          } else if (decodedData is Map<String, dynamic>) {
            if (decodedData['status'] == false) {
              return [];
            }
            rawList = decodedData['data'] ??
                decodedData['result'] ??
                decodedData['customerList'] ?? [];
          }

          return rawList
              .map((json) => CustomerItemModel.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception("Server Error (${response.statusCode}): Failed to load customer list");
        }
      } catch (e) {
        print('--- CUSTOMER LIST ERROR ---: $e');
        final errorStr = e.toString().replaceAll('Exception: ', '');
        if (errorStr.contains('SocketException') || errorStr.contains('ClientException')) {
          throw Exception("No internet connection. Please check your network.");
        }
        throw Exception(errorStr);
      }
    }
  }
}