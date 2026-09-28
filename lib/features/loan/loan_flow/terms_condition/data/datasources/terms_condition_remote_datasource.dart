import '../models/terms_response_model.dart';

abstract class TermsConditionRemoteDatasource {
  Future<TermsResponseModel> submitTerms({required bool isAccepted});
}

class TermsConditionRemoteDatasourceImpl implements TermsConditionRemoteDatasource {
  @override
  Future<TermsResponseModel> submitTerms({required bool isAccepted}) async {
    await Future.delayed(const Duration(seconds: 1));

    return TermsResponseModel(
      isAccepted: isAccepted,
      message: 'Terms and conditions accepted successfully',
    );
  }
}