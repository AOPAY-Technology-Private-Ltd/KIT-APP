class CustomerEntity {
  final String message;
  final bool success;
  final String? firstName;
  final String? lastName;
  final String? alternateMobileNumber;
  final String? emailID;
  final String? currentAddress;

  const CustomerEntity({
    required this.message,
    required this.success,
    this.firstName,
    this.lastName,
    this.alternateMobileNumber,
    this.emailID,
    this.currentAddress,
  });
}