abstract class UpdateEmiEvent {}

class FetchEmiDetailsEvent extends UpdateEmiEvent {}

class SubmitEmiEvent extends UpdateEmiEvent {
  final Map<String, dynamic> payload;
  SubmitEmiEvent(this.payload);
}