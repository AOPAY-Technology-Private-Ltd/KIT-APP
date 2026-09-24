import '../models/loan_customer_model.dart';

abstract class LoanCustomerRemoteDataSource {
  Future<List<LoanCustomerModel>> fetchLoanCustomers(String status);
}

class LoanCustomerRemoteDataSourceImpl implements LoanCustomerRemoteDataSource {
  LoanCustomerRemoteDataSourceImpl();

  @override
  Future<List<LoanCustomerModel>> fetchLoanCustomers(String status) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final List<Map<String, dynamic>> mockData = [
      {
        'id': '1',
        'name': 'Neha Sharma',
        'phone': '98105 64321',
        'email': 'neha.sharma@gmail.com',
        'profileImage': '',
        'loanId': 'LN202603184',
        'principal': '48,000',
        'monthlyEmi': '4,350',
        'nextPaymentDate': '18 Sep 2026',
        'emIsRemaining': '8 of 12',
        'status': 'On track',
      },
      {
        'id': '2',
        'name': 'Imran Khan',
        'phone': '99584 12076',
        'email': 'imran.khan@gmail.com',
        'profileImage': '',
        'loanId': 'LN202605097',
        'principal': '62,500',
        'monthlyEmi': '5,740',
        'nextPaymentDate': '15 Sep 2026',
        'emIsRemaining': '10 of 12',
        'status': 'Overdue',
      },
      {
        'id': '3',
        'name': 'Rahul Verma',
        'phone': '98765 43210',
        'email': 'rahul.verma@gmail.com',
        'profileImage': '',
        'loanId': 'LN202608912',
        'principal': '55,000',
        'monthlyEmi': '5,000',
        'nextPaymentDate': '25 Sep 2026',
        'emIsRemaining': '6 of 12',
        'status': 'Upcoming',
      },
    ];

    List<LoanCustomerModel> allCustomers = mockData
        .map((json) => LoanCustomerModel.fromJson(json))
        .toList();

    if (status.toLowerCase() == 'active') {
      return allCustomers;
    } else {
      return allCustomers
          .where((customer) => customer.status.toLowerCase() == status.toLowerCase())
          .toList();
    }
  }
}