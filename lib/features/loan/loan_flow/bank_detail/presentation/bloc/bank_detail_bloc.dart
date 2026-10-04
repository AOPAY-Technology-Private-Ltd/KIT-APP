import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_bank_detail_usecase.dart';
import '../../domain/usecases/get_bank_list_usecase.dart';
import 'bank_detail_event.dart';
import 'bank_detail_state.dart';

class BankDetailBloc extends Bloc<BankDetailEvent, BankDetailState> {
  final SubmitBankDetailUseCase submitBankDetailUseCase;
  final GetBankListUseCase getBankListUseCase;

  BankDetailBloc({
    required this.submitBankDetailUseCase,
    required this.getBankListUseCase,
  }) : super(BankDetailInitialState()) {

    on<SubmitBankDetailEvent>((event, emit) async {
      emit(BankDetailLoadingState());
      try {
        await submitBankDetailUseCase(event.entity);
        emit(BankDetailSuccessState());
      } catch (e) {
        emit(BankDetailErrorState(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<FetchBankListEvent>((event, emit) async {
      emit(BankDetailLoadingState());
      try {
        final banks = await getBankListUseCase(event.registrationId);
        emit(BankBankListLoadedState(banks));
      } catch (e) {
        emit(BankDetailErrorState(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}