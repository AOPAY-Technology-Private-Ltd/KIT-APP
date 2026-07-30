import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_request_model.dart';
import '../models/customer_response_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerResponseModel> verifyCustomerKit(CustomerRequestModel requestModel);
  Future<CustomerResponseModel> manageCustomer(CustomerRequestModel requestModel);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final http.Client client;

  CustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<CustomerResponseModel> verifyCustomerKit(CustomerRequestModel requestModel) async {
    final uri = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/KitVerifyCustomer');

    print('--- KIT VERIFY CUSTOMER REQUEST ---');
    print('URL: $uri');
    print('Body: ${jsonEncode(requestModel.toJson())}');

    final response = await client.post(
      uri,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestModel.toJson()),
    );

    print('--- KIT VERIFY CUSTOMER RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CustomerResponseModel.fromJson(data);
    } else {
      throw Exception("Failed to verify customer: ${response.body}");
    }
  }

  @override
  Future<CustomerResponseModel> manageCustomer(CustomerRequestModel requestModel) async {
    final uri = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/KitManageCustomer').replace(
      queryParameters: {
        'Mode': requestModel.mode ?? 'INSERT',
        'FirstName': requestModel.firstName ?? '',
        'LastName': requestModel.lastName ?? '',
        'PrimaryMobileNumber': requestModel.primaryMobileNumber ?? '',
        'AlternateMobileNumber': requestModel.alternateMobileNumber ?? '',
        'PrimaryMobileVerified': requestModel.primaryMobileVerified ?? 'yes',
        'PrimaryOTP': requestModel.primaryOTP ?? '',
        'EMailID': requestModel.emailID ?? '',
        'CurrentAddress': requestModel.currentAddress ?? '',
        'PinCode': requestModel.pinCode ?? '',
        'Country': requestModel.country ?? 'India',
        'StateName': requestModel.stateName ?? '',
        'CityName': requestModel.cityName ?? '',
        'IMEINumber1': requestModel.imeiNumber1 ?? '',
        'DOB': requestModel.dob ?? '',
        'PANNumber': requestModel.panNumber ?? '',
        'AadhaarNumber': requestModel.aadhaarNumber ?? '',
        'ForceInsert': requestModel.forceInsert?.toString() ?? 'false',
      },
    );

    print('--- MANAGE CUSTOMER REQUEST ---');
    print('URL: $uri');

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'accept': '*/*',
    });

    if (requestModel.custAadhaarFrontPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'CustAadharPhoto_File',
        requestModel.custAadhaarFrontPhotoFile!.path,
      ));
    }
    if (requestModel.custAadhaarBackPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'CustAadharBackPhoto_File',
        requestModel.custAadhaarBackPhotoFile!.path,
      ));
    }
    if (requestModel.custPanNumberPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'CustPanNumberPhoto_File',
        requestModel.custPanNumberPhotoFile!.path,
      ));
    }
    if (requestModel.custPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'CustPhoto_File',
        requestModel.custPhotoFile!.path,
      ));
    }

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    print('--- MANAGE CUSTOMER RESPONSE ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CustomerResponseModel.fromJson(data);
    } else {
      throw Exception("Failed to manage customer: ${response.body}");
    }
  }
}