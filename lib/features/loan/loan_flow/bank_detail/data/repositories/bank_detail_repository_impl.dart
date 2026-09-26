import '../../domain/entities/bank_detail_entity.dart';
import '../../domain/repositories/bank_detail_repository.dart';
import '../datasources/bank_detail_remote_data_source.dart';
import '../models/bank_detail_model.dart';

class BankDetailRepositoryImpl implements BankDetailRepository {
  final BankDetailRemoteDataSource remoteDataSource;

  BankDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitBankDetails(BankDetailEntity entity) async {
    final model = BankDetailModel.fromEntity(entity);
    await remoteDataSource.submitBankDetails(model);
  }
}