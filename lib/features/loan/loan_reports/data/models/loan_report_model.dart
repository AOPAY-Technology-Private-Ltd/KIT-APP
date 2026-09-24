import '../../domain/entities/loan_report_entity.dart';

class LoanReportModel extends LoanReportEntity {
  const LoanReportModel({
    required super.id,
    required super.customerName,
    required super.loanId,
    required super.disbursementDate,
    required super.loanAmount,
    required super.tenure,
    required super.emiAmount,
    required super.status,
  });

  factory LoanReportModel.fromJson(Map<String, dynamic> json) {
    return LoanReportModel(
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      loanId: json['loanId']?.toString() ?? '',
      disbursementDate: json['disbursementDate']?.toString() ?? '',
      loanAmount: (json['loanAmount'] as num?)?.toDouble() ?? 0.0,
      tenure: json['tenure']?.toString() ?? '',
      emiAmount: (json['emiAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'Active',
    );
  }
}