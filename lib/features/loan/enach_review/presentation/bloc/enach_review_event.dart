abstract class EnachReviewEvent {}

class SubmitEnachActionRequested extends EnachReviewEvent {
  final String customerId;
  final String status;
  final String remarks;

  SubmitEnachActionRequested({
    required this.customerId,
    required this.status,
    required this.remarks,
  });
}