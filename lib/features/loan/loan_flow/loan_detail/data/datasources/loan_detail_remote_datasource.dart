import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../../core/services/session_manager.dart';
import '../models/loan_detail_model.dart';

abstract class LoanDetailRemoteDataSource {
  Future<void> uploadLoanDetail(LoanDetailModel model);
}

class LoanDetailRemoteDataSourceImpl implements LoanDetailRemoteDataSource {
  @override
  Future<void> uploadLoanDetail(LoanDetailModel model) async {
    const String url = 'https://uatapi.aopay.co.in/api/V1/AopayFinance/AppLoan/ManageCustomerStepWise';

    final String? retailerCode = await SessionManager.getRetailerCode();
    final String? customerCode = await SessionManager.getCustomerCodeTwo();
    final String? clientCode = await SessionManager.getClientCode();

    double loanAmount = double.tryParse(model.loanAmount) ?? 0.0;
    double processFee = double.tryParse(model.processFees) ?? 0.0;
    double tenureMonths = model.tenure;
    double interestRate = model.interestRate;

    double tenureInYears = tenureMonths > 0 ? tenureMonths / 12.0 : 0.0;
    double calculatedInterest = (loanAmount * interestRate * tenureInYears) / 100.0;
    double totalPayable = loanAmount + calculatedInterest + processFee;
    double monthlyEmi = tenureMonths > 0 ? totalPayable / tenureMonths : 0.0;

    final Map<String, String> requestFields = {
      'Mode': 'UPDATE',
      'Step': '2',
      'CustomerCodes': customerCode ?? '',
      'clientcode': clientCode ?? '',
      'RetailerCode': retailerCode ?? '',
      'ProductCategory': model.productCategory,
      'BrandName': model.brand,
      'ModelName': model.model,
      'DownPayment': model.downPayment,
      'TotalAmountPayble': totalPayable.toStringAsFixed(2),
      'ProcessingFees': model.processFees,
      'ForcloseCharges': model.forecloseCharges,
      'InterestType': model.interestType,
      'Tenure': tenureMonths.toInt().toString(),
      'LoanAmount': model.loanAmount,
      'EMIAmount': monthlyEmi.toStringAsFixed(2),
      'LoanMode': 'Offline',
    };

    print('--- API REQUEST ---');
    print('URL: $url');
    print('Fields: $requestFields');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(requestFields);

      http.StreamedResponse streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('--- API RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedData = jsonDecode(response.body);

        bool isSuccess = decodedData['success'] ?? false;
        String message = decodedData['message'] ?? '';

        if (isSuccess || message.toLowerCase().contains('already completed')) {
          return;
        } else {
          throw Exception(message.isNotEmpty ? message : 'Failed to save loan details');
        }
      } else {
        throw Exception('Failed to upload loan details: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('--- API ERROR ---');
      print(e.toString());
      rethrow;
    }
  }
}