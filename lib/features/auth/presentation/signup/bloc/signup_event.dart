abstract class SignupEvent {}

class BusinessDetailsSubmitted extends SignupEvent {
  final String businessName;
  final String businessType;
  final String? gstType;

  BusinessDetailsSubmitted({
    required this.businessName,
    required this.businessType,
    this.gstType,
  });
}

class SignupSubmitted extends SignupEvent {
  final String businessName;
  final String businessType;
  final String? gstType;

  final String fullName;
  final String mobile;
  final String email;

  SignupSubmitted({
    required this.businessName,
    required this.businessType,
    this.gstType,
    required this.fullName,
    required this.mobile,
    required this.email,
  });
}