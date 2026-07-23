import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> fetchHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeModel> fetchHomeData() async {
    await Future.delayed(const Duration(seconds: 1));

    final dummyData = {
      "retailerName": "Reatilers Name",
      "retailerCode": "Reatilers Code",
      "availableKits": 128,
      "totalKits": 200,
      "totalInstalled": 184,
      "locked": 14,
      "todayInstalled": 20,
      "overdue": 18,
      "recentCustomers": [
        {"name": "Rahul Verma", "details": "Redmi Note 13, EMI Paid: 1/6", "time": "2min ago", "initials": "RV"},
        {"name": "Priya Sharma", "details": "Redmi Note 13, EMI Paid: 1/6", "time": "2min ago", "initials": "PS"},
      ]
    };

    return HomeModel.fromJson(dummyData);
  }
}