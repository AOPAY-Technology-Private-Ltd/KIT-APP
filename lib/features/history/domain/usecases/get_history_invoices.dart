import '../entities/entities.dart';
import '../repositories/history_repository.dart';

class GetHistoryInvoices {
  final HistoryRepository repository;

  GetHistoryInvoices(this.repository);

  Future<List<Invoice>> call() async {
    return await repository.getInvoices();
  }
}