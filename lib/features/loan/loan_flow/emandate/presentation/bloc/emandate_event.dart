abstract class EmandateEvent {}

class SubmitEmandateEvent extends EmandateEvent {
  final bool isAccepted;

  SubmitEmandateEvent(this.isAccepted);
}