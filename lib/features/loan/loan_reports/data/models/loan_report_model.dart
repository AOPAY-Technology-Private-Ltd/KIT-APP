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
      id: json['rid']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? 'Unknown',
      loanId: json['loanCode']?.toString() ?? '',
      disbursementDate: _formatDate(json['disbursedDate']),
      loanAmount: (json['disbursedAmount'] as num?)?.toDouble() ?? 0.0,
      tenure: '${json['tenure']?.toString() ?? '0'} Months',
      emiAmount: (json['emiAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['loanStatus']?.toString() ?? 'Disbursed',
    );
  }

  static String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(rawDate);
      final List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parsed.day.toString().padLeft(2, '0')} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (e) {
      return rawDate;
    }
  }
}