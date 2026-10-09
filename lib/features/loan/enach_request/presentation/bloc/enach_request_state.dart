import '../../domain/entities/enach_request_entity.dart';

abstract class EnachRequestState {}

class EnachRequestInitialState extends EnachRequestState {}

class EnachRequestLoadingState extends EnachRequestState {}

class EnachRequestLoadedState extends EnachRequestState {
  final List<EnachRequestEntity> requests;
  EnachRequestLoadedState(this.requests);
}

class EnachRequestErrorState extends EnachRequestState {
  final String message;
  EnachRequestErrorState(this.message);
}