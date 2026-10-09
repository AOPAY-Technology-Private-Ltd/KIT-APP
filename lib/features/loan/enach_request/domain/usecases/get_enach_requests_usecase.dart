import '../../domain/entities/enach_request_entity.dart';
import '../../domain/repositories/enach_request_repository.dart';

class GetEnachRequestsUsecase {
  final EnachRequestRepository repository;

  GetEnachRequestsUsecase(this.repository);

  Future<List<EnachRequestEntity>> call() async {
    return await repository.getEnachRequests();
  }
}