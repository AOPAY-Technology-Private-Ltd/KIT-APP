import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_loan_detail_usecase.dart';
import 'loan_detail_event.dart';
import 'loan_detail_state.dart';

class LoanDetailBloc extends Bloc<LoanDetailEvent, LoanDetailState> {
  final SubmitLoanDetailUseCase submitLoanDetailUseCase;

  LoanDetailBloc(this.submitLoanDetailUseCase) : super(LoanDetailInitialState()) {
    on<SubmitLoanDetailEvent>((event, emit) async {
      emit(LoanDetailLoadingState());
      try {
        await submitLoanDetailUseCase(event.loanDetail);
        emit(LoanDetailSuccessState());
      } catch (e) {
        emit(LoanDetailErrorState(e.toString()));
      }
    });
  }
}