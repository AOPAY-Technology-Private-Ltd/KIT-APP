import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/bank_detail_model.dart';

abstract class BankDetailRemoteDataSource {
  Future<void> submitBankDetails(BankDetailModel model);
  Future<List<String>> getBankList(String registrationId);
  Future<void> manageCustomerStepWise(BankDetailModel model, {String step = "3", String mode = "UPDATE"});

  Future<Map<String, String>> setupAutoUpiSubscription(String registrationId);
  Future<bool> checkOrderStatus({required String registrationId, required String merchantOrderId});

  Future<Map<String, String>> postTransactionWithResponse({required String registrationId, required String loanCode, required String emiNumbers});

  Future<void> manageCustomerStepWiseForStep4({required String registrationId});
}

class BankDetailRemoteDataSourceImpl implements BankDetailRemoteDataSource {
  final http.Client client;

  BankDetailRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitBankDetails(BankDetailModel model) async {
    final url = Uri.parse('https://api.aopay.in/api/AOP/V1/PennyDrop/Request');
    final requestBody = jsonEncode({
      "BankName": model.bankName,
      "IFSCCode": model.ifscCode,
      "AccountNumber": model.accountNumber,
      "BenificiaryName": model.beneficiaryName,
      "Address": model.branchName,
      "paymentMode": "IMPS",
      "RegistrationID": "AOP-554",
    });

    print('=== API REQUEST: PennyDrop/Request ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: PennyDrop/Request ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final modelData = decodedData['model'];
      final refId = (modelData is Map) ? (modelData['clientRefNum']?.toString() ?? '') : '';
      await checkPennyDropStatus(refId: refId, registrationId: "AOP-554", model: model);
    } else {
      throw Exception('Failed to submit bank details: ${response.statusCode}');
    }
  }

  Future<void> checkPennyDropStatus({
    required String refId,
    required String registrationId,
    required BankDetailModel model,
  }) async {
    final url = Uri.parse('https://api.aopay.in/api/AOP/V1/PennyDrop/CheckStatus');
    final requestBody = jsonEncode({"RefID": refId, "RegistrationID": registrationId});

    print('=== API REQUEST: PennyDrop/CheckStatus ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: PennyDrop/CheckStatus ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      await manageCustomerStepWise(model);
    } else {
      throw Exception('Failed to check status: ${response.statusCode}');
    }
  }

  @override
  Future<void> manageCustomerStepWise(BankDetailModel model, {String step = "3", String mode = "UPDATE"}) async {
    final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/ManageCustomerStepWise');
    final customerCode = await SessionManager.getCustomerCode() ?? '';
    final clientCode = await SessionManager.getClientCode() ?? '';

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
    });

    request.fields['Mode'] = mode;
    request.fields['Step'] = step;
    request.fields['CustomerCodes'] = customerCode;
    request.fields['clientcode'] = clientCode;
    request.fields['AccountNumber'] = model.accountNumber;
    request.fields['ConfirmAccountNumber'] = model.accountNumber;
    request.fields['BankIFSCCode'] = model.ifscCode;
    request.fields['BankName'] = model.bankName;
    request.fields['AccountType'] = "SAVINGS";
    request.fields['IsPannyDrop'] = "Yes";

    print('=== API REQUEST: ManageCustomerStepWise Step $step ===');
    print('URL: $url');
    print('Fields: ${request.fields}');

    var streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    print('=== API RESPONSE: ManageCustomerStepWise Step $step ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to manage customer step wise: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getBankList(String registrationId) async {
    final url = Uri.parse('https://api.aopay.in/api/AOP/Enach/V1/GetBankList');
    final requestBody = jsonEncode({"RegistrationID": registrationId});

    print('=== API REQUEST: GetBankList ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: GetBankList ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final dataMap = decodedData['data'];
      List<dynamic> bankListJson = [];

      if (dataMap is Map && dataMap.containsKey('banks')) {
        bankListJson = dataMap['banks'] ?? [];
      } else if (decodedData['data'] is List) {
        bankListJson = decodedData['data'];
      }

      return bankListJson.map((bank) {
        if (bank is Map) {
          return bank['name']?.toString() ?? bank['bankName']?.toString() ?? '';
        }
        return bank.toString();
      }).where((bankName) => bankName.isNotEmpty).toList();
    } else {
      throw Exception('Failed to load bank list: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, String>> setupAutoUpiSubscription(String registrationId) async {
    final url = Uri.parse('https://api.dikshifinsure.com/api/Aopay/Finance/Online/V1/SetupSubscription/Pennydrop');
    final requestBody = jsonEncode({"RegistrationID": registrationId});

    print('=== API REQUEST: SetupSubscription/Pennydrop ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: SetupSubscription/Pennydrop ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final intentUrl = decodedData['IntentUrl']?.toString() ?? '';
      final merchantOrderId = decodedData['MarchentOrderID']?.toString() ?? '';

      if (intentUrl.isNotEmpty) {
        return {
          'intentUrl': intentUrl,
          'merchantOrderId': merchantOrderId,
        };
      } else {
        throw Exception(decodedData['ErrorMessage'] ?? 'Failed to setup subscription');
      }
    } else {
      throw Exception('Failed to setup auto UPI subscription: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkOrderStatus({required String registrationId, required String merchantOrderId}) async {
    final url = Uri.parse('https://api.dikshifinsure.com/api/Aopay/Finance/Online/V1/SetupSubscription/Order/Status');
    final requestBody = jsonEncode({
      "RegistrationID": registrationId,
      "MerchantOrderId": merchantOrderId,
    });

    print('=== API REQUEST: Order/Status ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: Order/Status ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to check order status: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, String>> postTransactionWithResponse({required String registrationId, required String loanCode, required String emiNumbers}) async {
    final url = Uri.parse('https://api.dikshifinsure.com/api/Aopay/Finance/Online/V1/SetupSubscription/Transaction');
    final customerCode = await SessionManager.getCustomerCode() ?? '';
    final sessionLoanCode = loanCode.isNotEmpty ? loanCode : (await SessionManager.getLoanCode() ?? '');

    final requestBody = jsonEncode({
      "RegistrationID": registrationId,
      "Amount": 2,
      "customerCode": customerCode,
      "LoanCode": sessionLoanCode,
      "EMINumbers": "EMI1",
    });

    print('=== API REQUEST: SetupSubscription/Transaction ===');
    print('URL: $url');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: SetupSubscription/Transaction ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final intentUrl = decodedData['IntentUrl']?.toString() ?? '';
      final merchantOrderId = decodedData['MarchentOrderID']?.toString() ?? '';

      if (intentUrl.isNotEmpty) {
        return {
          'intentUrl': intentUrl,
          'merchantOrderId': merchantOrderId,
        };
      } else {
        throw Exception(decodedData['ErrorMessage'] ?? 'Failed to get transaction intent URL');
      }
    } else {
      throw Exception('Failed to post transaction: ${response.statusCode}');
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