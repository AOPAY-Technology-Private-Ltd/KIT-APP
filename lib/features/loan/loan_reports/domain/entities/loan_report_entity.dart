class LoanReportEntity {
  final String id;
  final String customerName;
  final String loanId;
  final String disbursementDate;
  final double loanAmount;
  final String tenure;
  final double emiAmount;
  final String status;

  const LoanReportEntity({
    required this.id,
    required this.customerName,
    required this.loanId,
    required this.disbursementDate,
    required this.loanAmount,
    required this.tenure,
    required this.emiAmount,
    required this.status,
  });
}

class LoanReportSummaryEntity {
  final int totalDisbursedCount;
  final double totalVolume;
  final List<LoanReportEntity> loans;

  const LoanReportSummaryEntity({
    required this.totalDisbursedCount,
    required this.totalVolume,
    required this.loans,
  });
}