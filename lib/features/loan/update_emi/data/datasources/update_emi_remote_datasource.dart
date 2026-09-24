import '../models/update_emi_request_model.dart';

abstract class UpdateEmiRemoteDataSource {
  Future<bool> submitEmiUpdate(UpdateEmiModel model);
}

class UpdateEmiRemoteDataSourceImpl implements UpdateEmiRemoteDataSource {
  UpdateEmiRemoteDataSourceImpl();

  @override
  Future<bool> submitEmiUpdate(UpdateEmiModel model) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}