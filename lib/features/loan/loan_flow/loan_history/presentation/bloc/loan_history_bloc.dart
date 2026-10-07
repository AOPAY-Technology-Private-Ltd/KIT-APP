import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_loan_portfolio_usecase.dart';
import 'loan_history_event.dart';
import 'loan_history_state.dart';


class LoanHistoryBloc extends Bloc<LoanHistoryEvent, LoanHistoryState> {
  final GetLoanPortfolioUsecase getLoanPortfolioUsecase;

  LoanHistoryBloc({required this.getLoanPortfolioUsecase}) : super(LoanHistoryInitialState()) {
    on<FetchLoanHistoryEvent>((event, emit) async {
      emit(LoanHistoryLoadingState());
      try {
        final portfolio = await getLoanPortfolioUsecase();
        emit(LoanHistoryLoadedState(portfolio: portfolio));
      } catch (e) {
        emit(LoanHistoryErrorState(message: e.toString()));
      }
    });
  }
}