import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_loan_customers_usecase.dart';
import 'loan_customer_event.dart';
import 'loan_customer_state.dart';

class LoanCustomerBloc extends Bloc<LoanCustomerEvent, LoanCustomerState> {
  final GetLoanCustomersUseCase getLoanCustomersUseCase;

  LoanCustomerBloc(this.getLoanCustomersUseCase) : super(LoanCustomerInitialState()) {
    on<FetchLoanCustomersEvent>((event, emit) async {
      emit(LoanCustomerLoadingState());
      try {
        final customers = await getLoanCustomersUseCase(event.status);
        emit(LoanCustomerLoadedState(customers));
      } catch (e) {
        emit(LoanCustomerErrorState(e.toString()));
      }
    });
  }
}