import '../models/enach_request_model.dart';

abstract class EnachRequestLocalDataSource {
  Future<List<EnachRequestModel>> fetchDummyRequests();
}

class EnachRequestLocalDataSourceImpl implements EnachRequestLocalDataSource {
  @override
  Future<List<EnachRequestModel>> fetchDummyRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const EnachRequestModel(
        id: '1',
        customerName: 'Katty Dharmajan',
        customerId: 'CUS-49210',
        appliedDate: '12 Sep 2026',
        status: 'Review',
        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      ),
      const EnachRequestModel(
        id: '2',
        customerName: 'Priya Mehta',
        customerId: 'CUS-49211',
        appliedDate: '11 Sep 2026',
        status: 'Review',
        imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
      ),
      const EnachRequestModel(
        id: '3',
        customerName: 'Rohan Gupta',
        customerId: 'CUS-49212',
        appliedDate: '10 Sep 2026',
        status: 'Review',
        imageUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
      ),
      const EnachRequestModel(
        id: '4',
        customerName: 'Katty Dharmajan',
        customerId: 'CUS-49210',
        appliedDate: '12 Sep 2026',
        status: 'Reviewed',
        imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
      ),
    ];
  }
}