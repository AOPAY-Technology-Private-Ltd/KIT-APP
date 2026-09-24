import '../../domain/entities/entities.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Invoice>> getInvoices() async {
    final invoiceModels = await localDataSource.getMockInvoices();
    return invoiceModels;
  }
}