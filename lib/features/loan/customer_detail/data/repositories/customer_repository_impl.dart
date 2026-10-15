import '../../domain/entities/customer_detail_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerDetailEntity> getCustomerDetail() async {
    final remoteData = await remoteDataSource.fetchCustomerDetail();
    return remoteData;
  }
}