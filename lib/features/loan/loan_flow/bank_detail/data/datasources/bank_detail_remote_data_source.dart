import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bank_detail_model.dart';

abstract class BankDetailRemoteDataSource {
  Future<void> submitBankDetails(BankDetailModel model);
  Future<List<String>> getBankList(String registrationId);
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
      "paymentMode": model.paymentMode,
      "RegistrationID": "AOP-554",
    });

    print('=== API REQUEST: PennyDrop Request ===');
    print('URL: $url');
    print('Headers: {"api-key": "...", "Content-Type": "application/json"}');
    print('Body: $requestBody');

    final response = await client.post(
      url,
      headers: {
        'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    print('=== API RESPONSE: PennyDrop Request ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      final status = decodedData['Status']?.toString();
      final message = decodedData['message']?.toString() ?? 'Something went wrong';

      if (status != 'True' && status != 'true') {
        throw Exception(message);
      }

      final refId = decodedData['Value']?.toString() ?? '';

      await checkPennyDropStatus(
        refId: refId,
        registrationId: "AOP-554",
      );

    } else {
      throw Exception('Failed to submit bank details: ${response.statusCode}');
    }
  }

  Future<void> checkPennyDropStatus({required String refId, required String registrationId}) async {
    final url = Uri.parse('https://api.aopay.in/api/AOP/V1/PennyDrop/CheckStatus');

    final requestBody = jsonEncode({
      "RefID": refId,
      "RegistrationID": registrationId,
    });

    print('=== API REQUEST: PennyDrop CheckStatus ===');
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

    print('=== API RESPONSE: PennyDrop CheckStatus ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final status = decodedData['Status']?.toString();
      final message = decodedData['message']?.toString() ?? 'Status check failed';

      if (status != 'True' && status != 'true') {
        throw Exception(message);
      }
    } else {
      throw Exception('Failed to check status: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getBankList(String registrationId) async {
    final url = Uri.parse('https://api.aopay.in/api/AOP/Enach/V1/GetBankList');

    final requestBody = jsonEncode({
      "RegistrationID": registrationId,
    });

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
}