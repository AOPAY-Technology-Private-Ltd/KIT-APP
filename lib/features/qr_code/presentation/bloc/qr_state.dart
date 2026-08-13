import '../../domain/entities/qr_user_entity.dart';

abstract class QrState {}

class QrInitialState extends QrState {}

class QrLoadingState extends QrState {}

class QrLoadedState extends QrState {
  final QrUserEntity user;
  QrLoadedState({required this.user});
}

class QrErrorState extends QrState {
  final String message;
  QrErrorState({required this.message});
}