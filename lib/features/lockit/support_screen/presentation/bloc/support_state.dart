import '../../domain/entities/support_entity.dart';

abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportLoaded extends SupportState {
  final List<FaqEntity> faqs;
  final SupportInfoEntity supportInfo;

  SupportLoaded({required this.faqs, required this.supportInfo});
}

class SupportError extends SupportState {
  final String message;
  SupportError(this.message);
}