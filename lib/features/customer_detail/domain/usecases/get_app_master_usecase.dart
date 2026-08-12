import '../../data/models/app_master_model.dart';
import '../repositories/customer_detail_repository.dart';

class GetAppMasterUseCase {
  final CustomerDetailRepository repository;

  GetAppMasterUseCase(this.repository);

  Future<AppMasterModel> call() async {
    return await repository.getAppMaster();
  }
}