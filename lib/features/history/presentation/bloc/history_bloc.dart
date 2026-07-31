import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_history_invoices.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryInvoices getHistoryInvoices;

  HistoryBloc({required this.getHistoryInvoices}) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<SearchHistoryEvent>(_onSearchHistory);
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final invoices = await getHistoryInvoices();
      emit(HistoryLoaded(invoices: invoices, filteredInvoices: invoices));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void _onSearchHistory(
      SearchHistoryEvent event, Emitter<HistoryState> emit) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      final query = event.query.toLowerCase();

      final filtered = currentState.invoices.where((invoice) {
        return invoice.invoiceNumber.toLowerCase().contains(query) ||
            invoice.date.toLowerCase().contains(query) ||
            invoice.amount.toString().contains(query);
      }).toList();

      emit(HistoryLoaded(
        invoices: currentState.invoices,
        filteredInvoices: filtered,
      ));
    }
  }
}