
import '../../domain/entities/entities.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Invoice> invoices;
  final List<Invoice> filteredInvoices;

  HistoryLoaded({required this.invoices, required this.filteredInvoices});
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}