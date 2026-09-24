class LoanCustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String profileImage;
  final String loanId;
  final String principal;
  final String monthlyEmi;
  final String nextPaymentDate;
  final String emIsRemaining;
  final String status;

  const LoanCustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.profileImage,
    required this.loanId,
    required this.principal,
    required this.monthlyEmi,
    required this.nextPaymentDate,
    required this.emIsRemaining,
    required this.status,
  });
}