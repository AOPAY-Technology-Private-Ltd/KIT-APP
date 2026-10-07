import 'package:bloc/bloc.dart';
import '../../domain/usecases/update_loan_disbursed_usecase.dart';
import 'loan_disbursed_event.dart';
import 'loan_disbursed_state.dart';

class LoanDisbursedBloc extends Bloc<LoanDisbursedEvent, LoanDisbursedState> {
  final UpdateLoanDisbursedUseCase updateLoanDisbursedUseCase;

  LoanDisbursedBloc(this.updateLoanDisbursedUseCase) : super(LoanDisbursedInitial()) {
    on<SubmitLoanDisbursedEvent>(_onSubmitLoanDisbursed);
  }

  Future<void> _onSubmitLoanDisbursed(
      SubmitLoanDisbursedEvent event,
      Emitter<LoanDisbursedState> emit,
      ) async {
    emit(LoanDisbursedLoading());

    try {
      await updateLoanDisbursedUseCase();
      emit(LoanDisbursedSuccess());
    } catch (e) {
      emit(LoanDisbursedError(e.toString()));
    }
  }
}