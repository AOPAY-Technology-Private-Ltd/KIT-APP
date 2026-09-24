import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/apiconstants/api_constants.dart';
import '../models/qr_user_model.dart';

abstract class QrRemoteDataSource {
  Future<QrUserModel> validateKey({required String apiKey});
  Future<QrUserModel> fetchQrData();
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  final http.Client client;

  QrRemoteDataSourceImpl({required this.client});

  @override
  Future<QrUserModel> validateKey({required String apiKey}) async {
    final url = Uri.parse(
        ApiConstants.validateKey);

    final requestBody = jsonEncode({
      "apiacessKey": apiKey,
    });

    debugPrint('🚀 [API Request] POST: $url');
    debugPrint('📦 [API Request Body]: $requestBody');

    try {
      final response = await client.post(
        url,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      debugPrint('📥 [API Response Status]: ${response.statusCode}');
      debugPrint('📥 [API Response Body]: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return QrUserModel(
            userName: data['message'] ?? 'Valid User',
            profileImageUrl: '',
            qrData: apiKey,
          );
        } else {
          throw Exception(data['message'] ?? 'Invalid API Key');
        }
      } else {
        throw Exception(
            'Failed to load data, Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [API Error]: $e');
      throw Exception('Error: $e');
    }
  }

  @override
  Future<QrUserModel> fetchQrData() async {
    final url = Uri.parse(
        ApiConstants.fetchQrData);

    debugPrint('🚀 [API Request] GET: $url');
    debugPrint('📋 [API Headers] accept: */*');

    try {
      final response = await client.get(
        url,
        headers: {
          'accept': '*/*',
        },
      );

      debugPrint('📥 [API Response Status]: ${response.statusCode}');

      if (response.statusCode == 200) {
        final String base64Image = base64Encode(response.bodyBytes);

        return QrUserModel(
          userName: 'iOS User',
          profileImageUrl: '',
          qrData: base64Image,
        );
      } else {
        throw Exception(
            'Failed to load iOS QR, Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [API Error]: $e');
      throw Exception('Error: $e');
    }
  }
}