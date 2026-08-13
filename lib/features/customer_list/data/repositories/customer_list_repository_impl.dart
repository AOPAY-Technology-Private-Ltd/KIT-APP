import '../../domain/entities/customer_item_entity.dart';
import '../../domain/repositories/customer_list_repository.dart';
import '../datasources/customer_list_remote_data_source.dart';

class CustomerListRepositoryImpl implements CustomerListRepository {
  final CustomerListRemoteDataSource remoteDataSource;

  CustomerListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CustomerItemEntity>> getCustomerList() async {
    return await remoteDataSource.getCustomerList();
  }
}