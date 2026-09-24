import '../../data/models/app_master_model.dart';
import '../repositories/customer_detail_repository.dart';

class GetAppMasterUseCase {
  final CustomerDetailRepository repository;

  GetAppMasterUseCase(this.repository);

  Future<AppMasterModel> call([String customerCode = '']) async {
    return await repository.getAppMaster(customerCode);
  }
}