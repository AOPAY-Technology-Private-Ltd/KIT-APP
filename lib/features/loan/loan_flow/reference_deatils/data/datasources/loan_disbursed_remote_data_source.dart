import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';

abstract class LoanDisbursedRemoteDataSource {
  Future<void> updateLoanDisbursedStep();
}

class LoanDisbursedRemoteDataSourceImpl implements LoanDisbursedRemoteDataSource {
  final http.Client client;

  LoanDisbursedRemoteDataSourceImpl({required this.client});

  @override
  Future<void> updateLoanDisbursedStep() async {
    final url = Uri.parse('https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/ManageCustomerStepWise');

    final customerCode = await SessionManager.getCustomerCode() ?? '';
    final clientCode = await SessionManager.getClientCode() ?? '';
    final rid = await SessionManager.getRid() ?? '';
    final retailerCode = await SessionManager.getRetailerCode() ?? '';

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'api-key': '78d794fea64a7a6e4a62390bd542f2aaac7cc6cae7d0db70d3909e1065470919',
    });

    request.fields['Mode'] = 'UPDATE';
    request.fields['Step'] = '6';
    request.fields['RID'] = rid;
    request.fields['CustomerCodes'] = customerCode;
    request.fields['IsAggrementVerified'] = 'Yes';
    request.fields['IsRetailerAggrementVerified'] = 'Yes';
    request.fields['CreatedBy'] = 'ADMIN';
    request.fields['RetailerCode'] = retailerCode;
    request.fields['clientcode'] = clientCode;

    print('=== API REQUEST: ManageCustomerStepWise Step 6 ===');
    print('URL: $url');
    print('Fields: ${request.fields}');

    var streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    print('=== API RESPONSE: ManageCustomerStepWise Step 6 ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('✅ Step 6 updated successfully!');
    } else {
      throw Exception('Failed to update step 6: ${response.statusCode}');
    }
  }
}