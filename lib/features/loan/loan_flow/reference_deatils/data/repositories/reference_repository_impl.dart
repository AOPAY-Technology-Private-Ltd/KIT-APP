import '../../domain/entities/reference_entity.dart';
import '../../domain/repositories/reference_repository.dart';
import '../datasources/reference_remote_data_source.dart';
import '../models/reference_model.dart';

class ReferenceRepositoryImpl implements ReferenceRepository {
  final ReferenceRemoteDataSource remoteDataSource;

  ReferenceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitReferenceDetail(ReferenceEntity referenceEntity) async {
    final model = ReferenceModel(
      firstName: referenceEntity.firstName,
      lastName: referenceEntity.lastName,
      relationship: referenceEntity.relationship,
      mobileNumber: referenceEntity.mobileNumber,
      address: referenceEntity.address,
    );
    await remoteDataSource.submitReference(model);
  }
}