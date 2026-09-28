abstract class TermsEvent {}

class SubmitTermsEvent extends TermsEvent {
  final bool isAccepted;
  SubmitTermsEvent({required this.isAccepted});
}