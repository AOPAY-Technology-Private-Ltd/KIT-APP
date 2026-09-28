abstract class ReferenceEvent {}

class SubmitReferenceEvent extends ReferenceEvent {
  final String firstName;
  final String lastName;
  final String? relationship;
  final String? mobileNumber;
  final String? address;

  SubmitReferenceEvent({
    required this.firstName,
    required this.lastName,
    this.relationship,
    this.mobileNumber,
    this.address,
  });
}