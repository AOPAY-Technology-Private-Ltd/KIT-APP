import '../models/customer_detail_model.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerDetailModel> fetchCustomerDetail();
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  @override
  Future<CustomerDetailModel> fetchCustomerDetail() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const CustomerDetailModel(
      customerName: 'Pinki Sethi',
      customerId: 'PS10069',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      status: 'Active',
      loanNumber: 'LN-2026-10069',
      nextEmiDate: '05, Oct, 2026',
      loanType: 'Personal Loan',
      loanCategory: 'Device Loan',
      emiAmount: 2250,
      loanAmount: 10800,
      downPayment: 7800,
      startDate: '5 July, 2026',
      endDate: '5 Dec, 2026',
      totalEmiCount: 6,
      paidEmiCount: 0,
    );
  }
}