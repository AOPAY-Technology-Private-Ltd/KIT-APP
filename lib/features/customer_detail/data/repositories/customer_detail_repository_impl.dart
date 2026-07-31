import '../../domain/entities/customer_detail_entity.dart';
import '../../domain/repositories/customer_detail_repository.dart';
import '../datasources/customer_detail_remote_data_source.dart';

class CustomerDetailRepositoryImpl implements CustomerDetailRepository {
  final CustomerDetailRemoteDataSource remoteDataSource;

  CustomerDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerDetailEntity> getCustomerDetail(String customerId) async {
    final customerModel = await remoteDataSource.getCustomerDetail(customerId);
    return customerModel;
  }
}