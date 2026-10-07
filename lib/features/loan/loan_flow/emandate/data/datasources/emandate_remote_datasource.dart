import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/emandate_model.dart';

abstract class EmandateRemoteDataSource {
  Future<void> submitEmandate(EmandateModel model);
  Future<void> checkEmandateStatus({required String emandateId, required String registrationId});
  Future<void> manageCustomerStepWiseForStep4({required String registrationId});
}

class EmandateRemoteDataSourceImpl implements EmandateRemoteDataSource {
  final http.Client client;

  EmandateRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitEmandate(EmandateModel model) async {
    if (!model.isAccepted) {
      throw Exception('Please accept the E-Mandate authorization terms.');
    }

    final url = Uri.parse('https://api.aopay.in/api/AOP/Enach/V1/eMandate');

    final requestBody = jsonEncode({
      "LoanNo": "LN0185",
      "SeqType": "RCUR",
      "FirstCollectionDate": "2027-03-05",
      "FinalCollectionDate": "2026-10-05",
      "CollectCollectionUntilCancle": true,
      "CollectionAmount": 6,
      "MobileNumber": "9971592326",
      "TeleNumber": "",
      "EmailAddress": "",
      "CategoryID": 7,
      "AccountHolderName": "Mohit",
      "BankID": 6,
      "authType": "",
      "AccountType": "Savings",
      "IFSCCode": "HDFC0004354",
      "BankAccountNumber": "50100337262186",
      "BankAccountNumberConfirmation": "50100337262186",
      "Frequncy": "MNTH",
      "DebitType": true,
      "AddIn2": "New Delhi",
      "AddIn3": "",
      "RegistrationID": "AOP-554"
    });

    print('=== API REQUEST: eMandate ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'Token': '',
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: eMandate ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      final dataMap = decodedData['data'];
      String emandateId = '';
      if (dataMap is Map) {
        final customerMap = dataMap['customer'];
        if (customerMap is Map) {
          emandateId = customerMap['id']?.toString() ?? '';
        }
      }

      final finalEmandateId = emandateId.isNotEmpty ? emandateId : "mul07ryhRJHm2V";

      await checkEmandateStatus(
        emandateId: finalEmandateId,
        registrationId: "AOP-554",
      );
    } else {
      throw Exception('Failed to submit e-mandate: ${response.statusCode}');
    }
  }

  @override
  Future<void> checkEmandateStatus({required String emandateId, required String registrationId}) async {
    final url = Uri.parse('https://api.aopay.in/api/AOP/Enach/V1/eMandate/getStatus');

    final requestBody = jsonEncode({
      "EMandateID": emandateId,
      "RegistrationID": registrationId,
    });

    print('=== API REQUEST: eMandate/getStatus ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'Token': '',
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: eMandate/getStatus ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      await manageCustomerStepWiseForStep4(registrationId: registrationId);
    } else {
      throw Exception('Failed to check eMandate status: ${response.statusCode}');
    }
  }

  @override
  Future<void> manageCustomerStepWiseForStep4({required String registrationId}) async {
    final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/ManageCustomerStepWise');

    final customerCode = await SessionManager.getCustomerCode() ?? '';
    final clientCode = await SessionManager.getClientCode() ?? '';
    final rid = await SessionManager.getRid() ?? '';
    final loanCode = await SessionManager.getLoanCode() ?? '';

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
    });

    request.fields['Mode'] = 'UPDATE';
    request.fields['Step'] = '4';
    request.fields['RID'] = rid;
    request.fields['LoanCode'] = loanCode;
    request.fields['CustomerCodes'] = customerCode;
    request.fields['DebitOrCreditCard'] = 'DEBIT';
    request.fields['UPIMandate'] = 'UPI';
    request.fields['IsEmandateVerified'] = 'Yes';
    request.fields['CreatedBy'] = 'ADMIN';
    request.fields['RetailerCode'] = '';
    request.fields['clientcode'] = clientCode;

    print('=== API REQUEST: ManageCustomerStepWise Step 4 ===');
    print('URL: $url');
    print('Fields: ${request.fields}');

    var streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    print('=== API RESPONSE: ManageCustomerStepWise Step 4 ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Step 4 updated successfully!');
    } else {
      throw Exception('Failed to update step 4: ${response.statusCode}');
    }
  }
}