import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getDevices();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final http.Client client;

  final bool useMockData;
  final String apiUrl;

  DeviceRemoteDataSourceImpl({
    required this.client,
    this.useMockData = true,
    this.apiUrl = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/GetDevices',
  });

  @override
  Future<List<DeviceModel>> getDevices() async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 800));

      final List<Map<String, dynamic>> mockJsonList = List.generate(
        10,
            (index) => {
          'id': '$index',
          'modelName': 'Model Name',
          'imageUrl': 'https://via.placeholder.com/150',
        },
      );

      return mockJsonList.map((json) => DeviceModel.fromJson(json)).toList();
    } else {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => DeviceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load devices from server');
      }
    }
  }
}