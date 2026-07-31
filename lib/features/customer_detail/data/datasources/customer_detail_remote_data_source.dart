import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_detail_model.dart';

abstract class CustomerDetailRemoteDataSource {
  Future<CustomerDetailModel> getCustomerDetail(String customerId);
}

class CustomerDetailRemoteDataSourceImpl implements CustomerDetailRemoteDataSource {
  final http.Client client;
  final bool useMockData;

  CustomerDetailRemoteDataSourceImpl({
    required this.client,
    this.useMockData = true,
  });

  @override
  Future<CustomerDetailModel> getCustomerDetail(String customerId) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));

      final Map<String, dynamic> mockData = {
        'id': customerId,
        'name': 'Pinki Sethi',
        'customerCode': 'PS10069',
        'email': 'pyaazaloo@gmail.com',
        'mobile': '+91 8989082401',
        'imei': '860543082547611',
        'address': 'Vipin Garden, Dwarka Mor, New Delhi Delhi, India, 110064',
        'imageUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
        'status': 'Active',
        'emiAmount': 2358.0,
        'emiDate': '05 July, 2026',
        'isLocked': false,
      };

      return CustomerDetailModel.fromJson(mockData);
    } else {
      final response = await client.get(Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/GetCustomerDetail?id=$customerId'));
      if (response.statusCode == 200) {
        return CustomerDetailModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load customer details');
      }
    }
  }
}