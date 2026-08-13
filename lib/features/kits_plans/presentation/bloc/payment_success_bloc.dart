import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/session_manager.dart';

import '../../data/models/save_purchase_history_request_model.dart';
import '../../domain/entities/payment_success_entity.dart';
import '../../domain/usecaes/save_purchase_history_usecase.dart';
import 'payment_success_event.dart';
import 'payment_success_state.dart';

class PaymentSuccessBloc extends Bloc<PaymentSuccessEvent, PaymentSuccessState> {
  final SavePurchaseHistoryUseCase savePurchaseHistoryUseCase;

  PaymentSuccessBloc({required this.savePurchaseHistoryUseCase})
      : super(PaymentSuccessInitialState()) {
    on<SaveAndInitializeSuccessEvent>(_onSaveAndInitialize);
  }

  Future<void> _onSaveAndInitialize(
      SaveAndInitializeSuccessEvent event,
      Emitter<PaymentSuccessState> emit,
      ) async {
    emit(PaymentSuccessSavingState());
    try {
      final retailerCode = await SessionManager.getRetailerCode() ?? '';

      final now = DateTime.now();
      final planEndDate = DateTime(now.year + 1, now.month, now.day);
      final requestModel = SavePurchaseHistoryRequestModel(
        companyCode: "CMP0005",
        purchaseCode: event.invoiceNo,
        retailerCode: retailerCode,
        mappingCode: event.mappingCode,
        planCode: event.planCode,
        planAmount: event.planAmount,
        discountAmount: event.discountAmount,
        gstAmount: event.gstAmount,
        netAmount: event.netAmount,
        paymentMode: event.paymentMode,
        transactionNo: event.invoiceNo,
        paymentReferenceNo: event.invoiceNo,
        paymentStatus: "SUCCESS",
        purchaseDate: now.toIso8601String(),
        planStartDate: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        planEndDate: "${planEndDate.year}-${planEndDate.month.toString().padLeft(2, '0')}-${planEndDate.day.toString().padLeft(2, '0')}",
        invoiceNo: event.invoiceNo,
        remarks: "Plan purchased successfully via ${event.paymentMode}",
        isActive: true,
        createdBy: retailerCode.isNotEmpty ? retailerCode : "Admin",
      );
      await savePurchaseHistoryUseCase.execute(requestModel);

      final entity = PaymentSuccessEntity(
        orderId: event.invoiceNo,
        kitsCount: event.kitsCount,
        totalPaid: event.netAmount,
        paymentMethod: event.paymentMode,
      );

      emit(PaymentSuccessLoadedState(entity));
    } catch (e) {
      final entity = PaymentSuccessEntity(
        orderId: event.invoiceNo,
        kitsCount: event.kitsCount,
        totalPaid: event.netAmount,
        paymentMethod: event.paymentMode,
      );
      emit(PaymentSuccessLoadedState(entity));
    }
  }
}