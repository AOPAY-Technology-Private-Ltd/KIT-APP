import '../../data/models/app_master_model.dart';
import '../entities/customer_detail_entity.dart';

abstract class CustomerDetailRepository {
  Future<CustomerDetailEntity> getCustomerDetail(String customerIdentifier);
  Future<AppMasterModel> getAppMaster();
}