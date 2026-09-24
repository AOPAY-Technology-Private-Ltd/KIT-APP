import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/qr_user_model.dart';
import '../../domain/usecases/get_qr_data_usecase.dart';
import 'qr_event.dart';
import 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  final GetQrDataUseCase getQrDataUseCase;

  QrBloc({required this.getQrDataUseCase}) : super(QrInitialState()) {
    on<LoadQrDataEvent>(_onLoadQrData);
    on<NextQrTappedEvent>(_onNextQrTapped);
    on<ValidateApiKeyEvent>(_onValidateApiKey);
  }

  Future<void> _onLoadQrData(
      LoadQrDataEvent event,
      Emitter<QrState> emit,
      ) async {
    emit(QrLoadingState());
    debugPrint('➡️ QrBloc: LoadQrDataEvent started...');

    try {
      final user = await getQrDataUseCase.validateKey(apiKey: "FNHLTGY2");
      debugPrint('✅ QrBloc: validateKey API success! User Name: ${user.userName}');

      final String provisioningQrPayload = jsonEncode({
        "android.app.extra.PROVISIONING_DEVICE_ADMIN_COMPONENT_NAME":
        "com.afwsamples.testdpc/com.afwsamples.testdpc.DeviceAdminReceiver",
        "android.app.extra.PROVISIONING_DEVICE_ADMIN_SIGNATURE_CHECKSUM":
        "gJD2YwtOiWJHkSMkkIfLRlj-quNqG1fb6v100QmzM9w=",
        "android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_DOWNLOAD_LOCATION":
        "https://uatapi.aopay.co.in/api/V1/AopayFinance/download-DPC",
        "android.app.extra.PROVISIONING_SKIP_ENCRYPTION": true,
        "android.app.extra.PROVISIONING_LEAVE_ALL_SYSTEM_APPS_ENABLED": true,
        "android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE": {}
      });

      final updatedUser = QrUserModel(
        userName: user.userName,
        profileImageUrl: user.profileImageUrl,
        qrData: provisioningQrPayload,
      );

      emit(QrLoadedState(user: updatedUser));
      debugPrint('🎉 QrBloc: QrLoadedState emitted with Android DPC QR data.');
    } catch (e) {
      debugPrint('❌ QrBloc Error: $e');
      emit(QrErrorState(message: e.toString()));
    }
  }

  Future<void> _onNextQrTapped(
      NextQrTappedEvent event,
      Emitter<QrState> emit,
      ) async {
    debugPrint('➡️ QrBloc: NextQrTappedEvent triggered (Fetching iOS QR)...');
    emit(QrLoadingState());

    try {
      final iosUser = await getQrDataUseCase.fetchIosQrData();
      debugPrint('✅ QrBloc: iOS QR API success! User Name: ${iosUser.userName}');

      emit(QrLoadedState(user: iosUser));
    } catch (e) {
      debugPrint('❌ QrBloc iOS API Error: $e');
      emit(QrErrorState(message: e.toString()));
    }
  }

  Future<void> _onValidateApiKey(
      ValidateApiKeyEvent event,
      Emitter<QrState> emit,
      ) async {
    emit(QrLoadingState());
    debugPrint('➡️ QrBloc: ValidateApiKeyEvent started with key: ${event.apiKey}');

    try {
      final user = await getQrDataUseCase.validateKey(apiKey: event.apiKey);
      debugPrint('✅ QrBloc: validateKey API success! User Name: ${user.userName}');

      final String provisioningQrPayload = jsonEncode({
        "android.app.extra.PROVISIONING_DEVICE_ADMIN_COMPONENT_NAME":
        "com.afwsamples.testdpc/com.afwsamples.testdpc.DeviceAdminReceiver",
        "android.app.extra.PROVISIONING_DEVICE_ADMIN_SIGNATURE_CHECKSUM":
        "gJD2YwtOiWJHkSMkkIfLRlj-quNqG1fb6v100QmzM9w=",
        "android.app.extra.PROVISIONING_DEVICE_ADMIN_PACKAGE_DOWNLOAD_LOCATION":
        "https://uatapi.aopay.co.in/api/V1/AopayFinance/download-DPC",
        "android.app.extra.PROVISIONING_SKIP_ENCRYPTION": true,
        "android.app.extra.PROVISIONING_LEAVE_ALL_SYSTEM_APPS_ENABLED": true,
        "android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE": {}
      });

      final updatedUser = QrUserModel(
        userName: user.userName,
        profileImageUrl: user.profileImageUrl,
        qrData: provisioningQrPayload,
      );

      emit(QrLoadedState(user: updatedUser));
      debugPrint('🎉 QrBloc: QrLoadedState emitted after validating key.');
    } catch (e) {
      debugPrint('❌ QrBloc Validation Error: $e');
      emit(QrErrorState(message: e.toString()));
    }
  }
}