import 'package:equatable/equatable.dart';

abstract class BasicDetailsState extends Equatable {
  const BasicDetailsState();

  @override
  List<Object?> get props => [];
}

class BasicDetailsInitialState extends BasicDetailsState {}

class BasicDetailsLoadingState extends BasicDetailsState {}

class OtpSentSuccessState extends BasicDetailsState {}

class OtpVerifiedSuccessState extends BasicDetailsState {
  final String message;
  const OtpVerifiedSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class CreditReportFetchedSuccessState extends BasicDetailsState {
  final Map<String, dynamic> reportData;
  const CreditReportFetchedSuccessState(this.reportData);

  @override
  List<Object?> get props => [reportData];
}

class BasicDetailsSubmittedSuccessState extends BasicDetailsState {}

class LoanIneligibleState extends BasicDetailsState {
  final String message;
  const LoanIneligibleState(this.message);

  @override
  List<Object?> get props => [message];
}

class BasicDetailsErrorState extends BasicDetailsState {
  final String message;

  const BasicDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}