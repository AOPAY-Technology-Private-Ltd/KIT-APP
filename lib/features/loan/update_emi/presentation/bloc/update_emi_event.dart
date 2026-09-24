
import '../../domain/entities/emi_customer_entity.dart';

abstract class UpdateEmiEvent {}

class SubmitEmiEvent extends UpdateEmiEvent {
  final EmiUpdateEntity emiEntity;
  SubmitEmiEvent(this.emiEntity);
}