import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/verify_customer_usecase.dart';
import '../../domain/usecases/manage_customer_usecase.dart';
import '../../data/models/customer_request_model.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final VerifyCustomerUseCase verifyCustomerUseCase;
  final ManageCustomerUseCase manageCustomerUseCase;

  CustomerBloc({
    required this.verifyCustomerUseCase,
    required this.manageCustomerUseCase,
  }) : super(CustomerInitial()) {
    on<KitVerifyRequested>(_onKitVerifyRequested);
    on<ManageCustomerSubmitted>(_onManageCustomerSubmitted);
  }

  Future<void> _onKitVerifyRequested(
      KitVerifyRequested event,
      Emitter<CustomerState> emit,
      ) async {
    emit(CustomerLoading());

    try {
      final result = await verifyCustomerUseCase(primaryMobileNumber: event.primaryMobileNumber);
      emit(CustomerSuccess(message: result.message.isNotEmpty ? result.message : "Verified Successfully!"));
    } catch (e) {
      emit(CustomerFailure(error: e.toString()));
    }
  }

  Future<void> _onManageCustomerSubmitted(
      ManageCustomerSubmitted event,
      Emitter<CustomerState> emit,
      ) async {
    emit(CustomerLoading());

    try {
      final requestModel = CustomerRequestModel(
        mode: "INSERT",
        firstName: event.firstName,
        lastName: event.lastName,
        primaryMobileNumber: event.primaryMobileNumber,
        alternateMobileNumber: event.alternateMobileNumber,
        primaryMobileVerified: "yes",
        emailID: event.emailID,
        currentAddress: event.currentAddress,
        country: "India",
        panNumber: event.panNumber,
        aadhaarNumber: event.aadharNumber,
        imeiNumber1: event.imeiNumber1,
        imeiNumber2: event.imeiNumber2,
        forceInsert: false,
        custPhotoFile: event.profileImage,
        custPanNumberPhotoFile: event.panImage,
        custAadhaarFrontPhotoFile: event.aadharFrontImage,
        custAadhaarBackPhotoFile: event.aadharBackImage,
        imeiNumberPhotoFile: event.imeiNumberPhotoFile,
        imeiNumber1SealPhotoFile: event.imeiNumber1SealPhotoFile,
        imeiNumber2SealPhotoFile: event.imeiNumber2SealPhotoFile,
        invoiceFile: event.invoiceFile,
      );

      final result = await manageCustomerUseCase(requestModel);
      emit(CustomerSuccess(
        message: result.message.isNotEmpty ? result.message : "Customer Saved Successfully!",
      ));
    } catch (e) {
      emit(CustomerFailure(error: e.toString()));
    }
  }
}