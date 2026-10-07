import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_bank_detail_usecase.dart';
import '../../domain/usecases/get_bank_list_usecase.dart';
import '../../domain/usecases/setup_auto_upi_usecase.dart';
import 'bank_detail_event.dart';
import 'bank_detail_state.dart';

class BankDetailBloc extends Bloc<BankDetailEvent, BankDetailState> {
  final SubmitBankDetailUseCase submitBankDetailUseCase;
  final GetBankListUseCase getBankListUseCase;
  final SetupAutoUpiUseCase setupAutoUpiUseCase;

  BankDetailBloc({
    required this.submitBankDetailUseCase,
    required this.getBankListUseCase,
    required this.setupAutoUpiUseCase,
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

    on<SetupAutoUpiEvent>((event, emit) async {
      emit(BankDetailLoadingState());
      try {
        final responseMap = await setupAutoUpiUseCase(event.registrationId);
        final intentUrl = responseMap['intentUrl'] ?? '';
        final merchantOrderId = responseMap['merchantOrderId'] ?? '';

        emit(AutoUpiUrlLoadedState(
          intentUrl: intentUrl,
          merchantOrderId: merchantOrderId,
        ));
      } catch (e) {
        emit(BankDetailErrorState(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<VerifyAndPostTransactionEvent>((event, emit) async {
      emit(BankDetailLoadingState());
      try {
        print('🚀 Starting PostTransaction API...');
        final transactionResponse = await setupAutoUpiUseCase.repository.postTransactionWithResponse(
          registrationId: event.registrationId,
          loanCode: event.loanCode,
          emiNumbers: event.emiNumbers,
        );

        final intentUrl = transactionResponse['intentUrl'] ?? '';
        final merchantOrderId = transactionResponse['merchantOrderId'] ?? '';
        print('✅ PostTransaction API Success');

        emit(TransactionUrlLoadedState(
          intentUrl: intentUrl,
          merchantOrderId: merchantOrderId,
        ));
      } catch (e) {
        print('❌ Error in VerifyAndPostTransactionEvent: $e');
        emit(BankDetailErrorState(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<CheckOrderAndStepFourEvent>((event, emit) async {
      emit(BankDetailLoadingState());
      try {
        print('🚀 Starting CheckOrderStatus API...');
        await setupAutoUpiUseCase.repository.checkOrderStatus(
          registrationId: event.registrationId,
          merchantOrderId: event.merchantOrderId,
        );
        print('✅ CheckOrderStatus API Success');

        print('🚀 Starting ManageCustomerStepWise Step 4 API...');
        await setupAutoUpiUseCase.repository.manageCustomerStepWiseForStep4(
          registrationId: event.registrationId,
        );
        print('✅ ManageCustomerStepWise Step 4 API Success');

        emit(BankDetailSuccessState());
      } catch (e) {
        print('❌ Error in CheckOrderAndStepFourEvent: $e');
        emit(BankDetailErrorState(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}