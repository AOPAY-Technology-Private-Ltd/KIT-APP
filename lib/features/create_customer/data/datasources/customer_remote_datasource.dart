import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/apiconstants/api_constants.dart';
import '../models/customer_request_model.dart';
import '../models/customer_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerResponseModel> verifyCustomerKit(CustomerRequestModel requestModel);
  Future<CustomerResponseModel> manageCustomer(CustomerRequestModel requestModel);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final http.Client client;

  CustomerRemoteDataSourceImpl({required this.client});

  @override
  Future<CustomerResponseModel> verifyCustomerKit(
      CustomerRequestModel requestModel) async {
    final uri = Uri.parse(ApiConstants.verifyCustomerKit);

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
  Future<CustomerResponseModel> manageCustomer(
      CustomerRequestModel requestModel) async {

    final prefs = await SharedPreferences.getInstance();
    final retailerCode = prefs.getString('retailer_code');
    final clientCode = prefs.getString('client_code');

    final queryParams = <String, String>{
      'Mode': requestModel.mode ?? 'INSERT',
      'PrimaryMobileVerified': requestModel.primaryMobileVerified ?? 'yes',
      'ForceInsert': requestModel.forceInsert?.toString() ?? 'false',
    };

    if (retailerCode != null && retailerCode.isNotEmpty) {
      queryParams['RetailerCode'] = retailerCode;
    }

    if (clientCode != null && clientCode.isNotEmpty) {
      queryParams['ClientCode'] = clientCode;
    }

    if (requestModel.firstName != null && requestModel.firstName!.isNotEmpty) {
      queryParams['FirstName'] = requestModel.firstName!;
    }
    if (requestModel.lastName != null && requestModel.lastName!.isNotEmpty) {
      queryParams['LastName'] = requestModel.lastName!;
    }
    if (requestModel.primaryMobileNumber != null &&
        requestModel.primaryMobileNumber!.isNotEmpty) {
      queryParams['PrimaryMobileNumber'] = requestModel.primaryMobileNumber!;
    }
    if (requestModel.alternateMobileNumber != null &&
        requestModel.alternateMobileNumber!.isNotEmpty) {
      queryParams['AlternateMobileNumber'] =
      requestModel.alternateMobileNumber!;
    }
    if (requestModel.emailID != null && requestModel.emailID!.isNotEmpty) {
      queryParams['EMailID'] = requestModel.emailID!;
    }
    if (requestModel.currentAddress != null &&
        requestModel.currentAddress!.isNotEmpty) {
      queryParams['CurrentAddress'] = requestModel.currentAddress!;
    }
    if (requestModel.imeiNumber1 != null &&
        requestModel.imeiNumber1!.isNotEmpty) {
      queryParams['IMEINumber1'] = requestModel.imeiNumber1!;
    }
    if (requestModel.imeiNumber2 != null &&
        requestModel.imeiNumber2!.isNotEmpty) {
      queryParams['IMEINumber2'] = requestModel.imeiNumber2!;
    }
    if (requestModel.panNumber != null && requestModel.panNumber!.isNotEmpty) {
      queryParams['PANNumber'] = requestModel.panNumber!;
    }
    if (requestModel.aadhaarNumber != null &&
        requestModel.aadhaarNumber!.isNotEmpty) {
      queryParams['AadhaarNumber'] = requestModel.aadhaarNumber!;
    }

    final uri = Uri.parse(ApiConstants.manageCustomer).replace(
      queryParameters: queryParams,
    );

    print('--- MANAGE CUSTOMER REQUEST ---');
    print('URL: $uri');

    print('--- QUERY PARAMETERS BODY ---');
    queryParams.forEach((key, value) {
      print('$key: $value');
    });

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
    if (requestModel.imeiNumberPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'IMEINumberPhotoFile',
        requestModel.imeiNumberPhotoFile!.path,
      ));
    }
    if (requestModel.imeiNumber1SealPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'IMEINumber1_SealPhotoFile',
        requestModel.imeiNumber1SealPhotoFile!.path,
      ));
    }
    if (requestModel.imeiNumber2SealPhotoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'IMEINumber2_SealPhotoFile',
        requestModel.imeiNumber2SealPhotoFile!.path,
      ));
    }
    if (requestModel.invoiceFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'InvoiceFile',
        requestModel.invoiceFile!.path,
      ));
    }

    if (request.fields.isNotEmpty) {
      print('--- REQUEST FIELDS ---');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });
    }

    print('--- ATTACHED FILES DETAILS ---');
    if (request.files.isEmpty) {
      print('No files attached to this request.');
    } else {
      for (var file in request.files) {
        print('Field Name: ${file.field} | File Path: ${file.filename ?? file.field}');
      }
    }
    print('--------------------------------');

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