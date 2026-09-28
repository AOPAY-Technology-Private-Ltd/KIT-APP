import '../models/emandate_model.dart';

abstract class EmandateRemoteDataSource {
  Future<void> submitEmandate(EmandateModel model);
}

class EmandateRemoteDataSourceImpl implements EmandateRemoteDataSource {
  @override
  Future<void> submitEmandate(EmandateModel model) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!model.isAccepted) {
      throw Exception('Please accept the E-Mandate authorization terms.');
    }
  }
}