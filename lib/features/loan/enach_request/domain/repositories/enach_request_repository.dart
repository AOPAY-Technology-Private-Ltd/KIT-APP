import '../entities/enach_request_entity.dart';

abstract class EnachRequestRepository {
  Future<List<EnachRequestEntity>> getEnachRequests();
}