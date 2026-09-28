import '../entities/reference_entity.dart';

abstract class ReferenceRepository {
  Future<void> submitReferenceDetail(ReferenceEntity referenceEntity);
}