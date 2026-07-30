abstract class SignupEvent {}

class SendOtpRequested extends SignupEvent {
  final String mobileOrEmailID;
  final String? customerName;
  final String? otp;

  SendOtpRequested({
    required this.mobileOrEmailID,
    this.customerName,
    this.otp,
  });
}

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
  final String? gstNumber;

  final String firstName;
  final String lastName;
  final String mobile;
  final String email;

  SignupSubmitted({
    required this.businessName,
    required this.businessType,
    this.gstNumber,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
  });
}