import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../../core/constants/apiconstants/api_constants.dart';
import '../../../../../core/helper/api_client.dart';
import '../../../../../core/services/session_manager.dart';
import '../../domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileEntity> fetchProfile() async {
    final firstName = await SessionManager.getFirstName() ?? 'User';
    final lastName = await SessionManager.getLastName() ?? '';
    final mobileNo = await SessionManager.getMobileNo() ?? '';
    final emailID = await SessionManager.getEmailID() ?? '';
    final retailerCode = await SessionManager.getRetailerCode() ?? '';

    int kitBalance = 0;
    int totalKits = 0;

    try {
      if (retailerCode.isNotEmpty) {
        final url = Uri.parse(ApiConstants.fetchHomeData);
        final requestBody = jsonEncode({"retailerCode": retailerCode});

        debugPrint('--- PROFILE KIT REPORT REQUEST ---');
        debugPrint('URL: $url');
        debugPrint('Body: $requestBody');

        final response = await ApiClient.post(
          url,
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          body: requestBody,
        ).timeout(const Duration(seconds: 15));

        debugPrint('--- PROFILE KIT REPORT RESPONSE ---');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Body: ${response.body}');

        if (response.statusCode == 200) {
          final decodedData = jsonDecode(response.body);
          if (decodedData['status'] == true || decodedData['data'] != null) {
            final data = decodedData['data'];
            kitBalance = data['availableKits'] ?? 0;
            totalKits = data['totalKits'] ?? 0;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching kit report in profile: $e');
    }

    final Map<String, dynamic> jsonMap = {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'emailID': emailID,
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'kitBalance': kitBalance,
      'totalKits': totalKits,
      'retailerCode': retailerCode,
    };

    return ProfileModel.fromJson(jsonMap);
  }
}