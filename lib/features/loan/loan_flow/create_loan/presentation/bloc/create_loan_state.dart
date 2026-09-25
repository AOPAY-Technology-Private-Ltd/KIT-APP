import 'package:equatable/equatable.dart';

abstract class CreateLoanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateLoanInitialState extends CreateLoanState {}

class CreateLoanLoadingState extends CreateLoanState {}

class PanVerifiedState extends CreateLoanState {}

class AadhaarVerifiedState extends CreateLoanState {}

class DocumentsSubmittedSuccessState extends CreateLoanState {}

class CreateLoanErrorState extends CreateLoanState {
  final String message;
  CreateLoanErrorState(this.message);

  @override
  List<Object?> get props => [message];
}