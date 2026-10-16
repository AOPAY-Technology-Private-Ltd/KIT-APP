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

    final String loanCode = await SessionManager.getLoanCode() ?? '';
    final String customerCode = await SessionManager.getCustomerCode() ?? await SessionManager.getCustomerCodeTwo() ?? '';
    final String customerMobile = await SessionManager.getCustomerMobileNo() ?? await SessionManager.getMobileNo() ?? '';
    final String emailAddress = await SessionManager.getEmailID() ?? '';

    final String accountNumber = await SessionManager.getAccountNumber() ?? '';
    final String ifscCode = await SessionManager.getIfscCode() ?? '';
    final String accountType = await SessionManager.getAccountType() ?? 'Savings';
    final String beneficiaryName = await SessionManager.getBeneficiaryName() ?? '';
    final String bankIdStr = await SessionManager.getBankId() ?? '6';
    final int bankId = int.tryParse(bankIdStr) ?? 6;

    final String startDate = await SessionManager.getStartDate() ?? '';
    final String endDate = await SessionManager.getEndDate() ?? '';
    final String firstName = await SessionManager.getFirstName() ?? '';
    final String lastName = await SessionManager.getLastName() ?? '';

    final String fullAccountHolderName = beneficiaryName.isNotEmpty
        ? beneficiaryName
        : "$firstName $lastName".trim();

    final String registrationId = customerCode.isNotEmpty
        ? 'AOP-$customerCode'
        : 'AOP-${DateTime.now().millisecondsSinceEpoch}';

    final requestBody = jsonEncode({
      "LoanNo": loanCode,
      "SeqType": "RCUR",
      "FirstCollectionDate": startDate.isNotEmpty ? startDate : "",
      "FinalCollectionDate": endDate.isNotEmpty ? endDate : "",
      "CollectCollectionUntilCancle": true,
      "CollectionAmount": 6,
      "MobileNumber": customerMobile,
      "TeleNumber": "",
      "EmailAddress": emailAddress,
      "CategoryID": 7,
      "AccountHolderName": fullAccountHolderName,
      "BankID": bankId,
      "authType": "DebitCard",
      "AccountType": accountType,
      "IFSCCode": ifscCode,
      "BankAccountNumber": accountNumber,
      "BankAccountNumberConfirmation": accountNumber,
      "Frequncy": "MNTH",
      "DebitType": true,
      "AddIn2": "New Delhi",
      "AddIn3": "",
      "RegistrationID": registrationId
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);

      String emandateId = '';
      final dataMap = decodedData['data'];
      if (dataMap is Map) {
        final customerMap = dataMap['customer'];
        if (customerMap is Map) {
          emandateId = customerMap['id']?.toString() ?? '';
        }
      }

      if (emandateId.isNotEmpty) {
        await checkEmandateStatus(
          emandateId: emandateId,
          registrationId: registrationId,
        );
      } else {
        throw Exception('eMandate ID not received in API response');
      }
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      await manageCustomerStepWiseForStep4(registrationId: registrationId);
    } else {
      throw Exception('Failed to check eMandate status: ${response.statusCode}');
    }
  }

  @override
  Future<void> manageCustomerStepWiseForStep4({required String registrationId}) async {
    final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/ManageCustomerStepWise');

    final customerCode = await SessionManager.getCustomerCode() ?? await SessionManager.getCustomerCodeTwo() ?? '';
    final clientCode = await SessionManager.getClientCode() ?? '';
    final retailerCode = await SessionManager.getRetailerCode() ?? '';
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
    request.fields['RetailerCode'] = retailerCode;
    request.fields['clientcode'] = clientCode;

    print('=== API REQUEST: ManageCustomerStepWise Step 4 ===');
    print('URL: $url');
    print('Fields: ${request.fields}');

    var streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    print('=== API RESPONSE: ManageCustomerStepWise Step 4 ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Step 4 updated successfully!');
    } else {
      throw Exception('Failed to update step 4: ${response.statusCode}');
    }
  }
}