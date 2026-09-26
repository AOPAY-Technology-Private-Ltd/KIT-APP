import 'package:equatable/equatable.dart';

abstract class BasicDetailsState extends Equatable {
  const BasicDetailsState();

  @override
  List<Object?> get props => [];
}

class BasicDetailsInitialState extends BasicDetailsState {}

class BasicDetailsLoadingState extends BasicDetailsState {}

class BasicDetailsSubmittedSuccessState extends BasicDetailsState {}

class BasicDetailsErrorState extends BasicDetailsState {
  final String message;

  const BasicDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}