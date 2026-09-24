import '../models/loan_report_model.dart';

abstract class LoanReportRemoteDataSource {
  Future<Map<String, dynamic>> fetchReports(String status);
}

class LoanReportRemoteDataSourceImpl implements LoanReportRemoteDataSource {
  @override
  Future<Map<String, dynamic>> fetchReports(String status) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<Map<String, dynamic>> mockData = [
      {
        'id': '1',
        'customerName': 'Rahul Verma',
        'loanId': 'LN-20241',
        'disbursementDate': '15 Jan 2024',
        'loanAmount': 150000.0,
        'tenure': '12 Months',
        'emiAmount': 13500.0,
        'status': 'Active',
      },
      {
        'id': '2',
        'customerName': 'Priya Sharma',
        'loanId': 'LN-20242',
        'disbursementDate': '22 Feb 2024',
        'loanAmount': 200000.0,
        'tenure': '24 Months',
        'emiAmount': 9500.0,
        'status': 'Active',
      },
      {
        'id': '3',
        'customerName': 'Arjun Mehta',
        'loanId': 'LN-20243',
        'disbursementDate': '10 Mar 2024',
        'loanAmount': 75000.0,
        'tenure': '6 Months',
        'emiAmount': 13200.0,
        'status': 'Overdue',
      },
      {
        'id': '4',
        'customerName': 'Sneha Kapoor',
        'loanId': 'LN-20244',
        'disbursementDate': '05 Apr 2024',
        'loanAmount': 350000.0,
        'tenure': '36 Months',
        'emiAmount': 11000.0,
        'status': 'Settled',
      },
      {
        'id': '5',
        'customerName': 'Vikram Singh',
        'loanId': 'LN-20245',
        'disbursementDate': '18 May 2024',
        'loanAmount': 125000.0,
        'tenure': '18 Months',
        'emiAmount': 7500.0,
        'status': 'Closed',
      },
      {
        'id': '6',
        'customerName': 'Amit Patel',
        'loanId': 'LN-20246',
        'disbursementDate': '01 Jun 2024',
        'loanAmount': 50000.0,
        'tenure': '9 Months',
        'emiAmount': 6000.0,
        'status': 'Active',
      },
    ];

    List<LoanReportModel> allLoans = mockData
        .map((json) => LoanReportModel.fromJson(json))
        .toList();

    int totalCount = allLoans.length;
    double totalVolume = allLoans.fold(0.0, (sum, item) => sum + item.loanAmount);

    List<LoanReportModel> filteredLoans = allLoans;
    if (status.toLowerCase() != 'all') {
      filteredLoans = allLoans
          .where((item) => item.status.toLowerCase() == status.toLowerCase())
          .toList();
    }

    return {
      'totalCount': totalCount,
      'totalVolume': totalVolume,
      'loans': filteredLoans,
    };
  }
}