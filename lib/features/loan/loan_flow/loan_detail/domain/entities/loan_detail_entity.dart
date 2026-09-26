class LoanDetailEntity {
  final String productCategory;
  final String brand;
  final String model;
  final String loanAmount;
  final String downPayment;
  final String processFees;
  final String forecloseCharges;
  final String interestType;
  final double tenure;
  final double interestRate;

  LoanDetailEntity({
    required this.productCategory,
    required this.brand,
    required this.model,
    required this.loanAmount,
    required this.downPayment,
    required this.processFees,
    required this.forecloseCharges,
    required this.interestType,
    required this.tenure,
    required this.interestRate,
  });
}