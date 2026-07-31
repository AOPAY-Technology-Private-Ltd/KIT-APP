
import '../entities/entities.dart';

abstract class HistoryRepository {
  Future<List<Invoice>> getInvoices();
}