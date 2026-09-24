import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_loan_reports_usecase.dart';
import 'loan_report_event.dart';
import 'loan_report_state.dart';

class LoanReportBloc extends Bloc<LoanReportEvent, LoanReportState> {
  final GetLoanReportsUseCase getLoanReportsUseCase;

  LoanReportBloc(this.getLoanReportsUseCase) : super(LoanReportInitialState()) {
    on<FetchLoanReportsEvent>((event, emit) async {
      emit(LoanReportLoadingState());
      try {
        final summary = await getLoanReportsUseCase(event.status);
        emit(LoanReportLoadedState(summary: summary, selectedFilter: event.status));
      } catch (e) {
        emit(LoanReportErrorState(e.toString()));
      }
    });
  }
}