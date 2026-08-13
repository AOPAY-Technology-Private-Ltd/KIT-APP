import '../../domain/repositories/customer_detail_repository.dart';
import '../datasources/customer_detail_remote_data_source.dart';
import '../models/app_master_model.dart';
import '../../domain/entities/customer_detail_entity.dart';

class CustomerDetailRepositoryImpl implements CustomerDetailRepository {
  final CustomerDetailRemoteDataSource remoteDataSource;

  CustomerDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerDetailEntity> getCustomerDetail(String customerIdentifier) async {
    return await remoteDataSource.getCustomerDetail(customerIdentifier);
  }

  @override
  Future<AppMasterModel> getAppMaster() async {
    return await remoteDataSource.getAppMaster();
  }
}