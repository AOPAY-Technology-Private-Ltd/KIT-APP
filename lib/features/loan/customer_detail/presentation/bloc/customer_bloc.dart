import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_customer_detail_usecase.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomerDetailUseCase getCustomerDetailUseCase;

  CustomerBloc({required this.getCustomerDetailUseCase}) : super(CustomerInitialState()) {
    on<FetchCustomerDetailEvent>((event, emit) async {
      emit(CustomerLoadingState());
      try {
        final customer = await getCustomerDetailUseCase();
        emit(CustomerLoadedState(customer: customer));
      } catch (e) {
        emit(CustomerErrorState(message: e.toString()));
      }
    });
  }
}