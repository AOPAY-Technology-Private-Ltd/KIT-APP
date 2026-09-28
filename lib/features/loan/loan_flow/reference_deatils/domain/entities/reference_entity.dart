class ReferenceEntity {
  final String firstName;
  final String lastName;
  final String? relationship;
  final String? mobileNumber;
  final String? address;

  const ReferenceEntity({
    required this.firstName,
    required this.lastName,
    this.relationship,
    this.mobileNumber,
    this.address,
  });
}