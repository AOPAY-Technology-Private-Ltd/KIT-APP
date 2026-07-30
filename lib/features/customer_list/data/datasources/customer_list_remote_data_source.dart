import 'dart:convert';
import 'package:http/http.dart' as http;

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
    this.useMockData = true,
    this.apiUrl = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/GetCustomerList',
  });

  @override
  Future<List<CustomerItemModel>> getCustomerList() async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data matching your design UI exactly
      final List<Map<String, dynamic>> mockList = [
        {
          'id': '1',
          'name': 'Pinki Sethi',
          'customerIdCode': 'PS1234567809',
          'email': 'pyaazaloo@gmai.com',
          'imageUrl': '',
          'mobile': '8929898901',
          'imei1': '869663047581173',
          'imei2': '869663047581165',
          'serialNumber': '1781092325834',
          'purchaseDate': '10-06-2026, 05:22 PM',
          'scheduleLockStatus': 'ON',
          'isLocked': false,
        },
        {
          'id': '2',
          'name': 'Pinki Sethi',
          'customerIdCode': 'PS1234567809',
          'email': 'pyaazaloo@gmai.com',
          'imageUrl': '',
          'mobile': '8929898901',
          'imei1': '869663047581173',
          'imei2': '869663047581165',
          'serialNumber': '1781092325834',
          'purchaseDate': '10-06-2026, 05:22 PM',
          'scheduleLockStatus': 'ON',
          'isLocked': true,
        },
        {
          'id': '3',
          'name': 'Pinki Sethi',
          'customerIdCode': 'PS1234567809',
          'email': 'pyaazaloo@gmai.com',
          'imageUrl': '',
          'mobile': '8929898901',
          'imei1': '869663047581173',
          'imei2': '869663047581165',
          'serialNumber': '1781092325834',
          'purchaseDate': '10-06-2026, 05:22 PM',
          'scheduleLockStatus': 'OFF',
          'isLocked': false,
        },

        {
          'id': '4',
          'name': 'Pinki Sethi',
          'customerIdCode': 'PS1234567809',
          'email': 'pyaazaloo@gmai.com',
          'imageUrl': '',
          'mobile': '8929898901',
          'imei1': '869663047581173',
          'imei2': '869663047581165',
          'serialNumber': '1781092325834',
          'purchaseDate': '10-06-2026, 05:22 PM',
          'scheduleLockStatus': 'OFF',
          'isLocked': false,
        },
      ];

      return mockList.map((json) => CustomerItemModel.fromJson(json)).toList();
    } else {
      final response = await client.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => CustomerItemModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customer list');
      }
    }
  }
}