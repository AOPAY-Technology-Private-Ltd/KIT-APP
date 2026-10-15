import '../../data/models/update_emi_request_model.dart';

abstract class UpdateEmiState {}

class UpdateEmiInitial extends UpdateEmiState {}
class UpdateEmiLoading extends UpdateEmiState {}

class EmiDetailsLoadedState extends UpdateEmiState {
  final EmiPaymentDetailModel emiDetails;
  EmiDetailsLoadedState({required this.emiDetails});
}

class UpdateEmiSuccess extends UpdateEmiState {
  final String message;
  UpdateEmiSuccess({required this.message});
}

class UpdateEmiError extends UpdateEmiState {
  final String message;
  UpdateEmiError({required this.message});
}