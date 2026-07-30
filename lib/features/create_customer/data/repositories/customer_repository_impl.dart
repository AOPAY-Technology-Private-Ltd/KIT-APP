import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../data/models/customer_request_model.dart';
import '../../data/models/customer_response_model.dart';
import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerEntity> verifyCustomerKit({required String primaryMobileNumber}) async {
    final requestModel = CustomerRequestModel(primaryMobileNumber: primaryMobileNumber);
    final response = await remoteDataSource.verifyCustomerKit(requestModel);
    return response;
  }

  @override
  Future<CustomerResponseModel> manageCustomer(CustomerRequestModel requestModel) async {
    return await remoteDataSource.manageCustomer(requestModel);
  }

  @override
  Future<CustomerEntity> createCustomer({
    required String name,
    required String mobile,
    required String email,
  }) async {
    throw UnimplementedError('createCustomer API is not implemented yet.');
  }
}