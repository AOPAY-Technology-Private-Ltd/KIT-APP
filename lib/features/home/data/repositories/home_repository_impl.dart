import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<HomeEntity> getHomeData() async {
    final homeModel = await remoteDataSource.fetchHomeData();

    List<CustomerEntity> recentCustomersList = homeModel.recentCustomers;

    try {
      recentCustomersList = await remoteDataSource.fetchRecentCustomers();
    } catch (e) {
      print("Failed to fetch recent customers API, using fallback: $e");
    }

    return HomeEntity(
      retailerName: homeModel.retailerName,
      retailerCode: homeModel.retailerCode,
      availableKits: homeModel.availableKits,
      totalKits: homeModel.totalKits,
      totalInstalled: homeModel.totalInstalled,
      locked: homeModel.locked,
      todayInstalled: homeModel.todayInstalled,
      overdue: homeModel.overdue,
      totalPurchasedKits: homeModel.totalPurchasedKits,
      usedKits: homeModel.usedKits,
      lockedDevices: homeModel.lockedDevices,
      unlockedDevices: homeModel.unlockedDevices,
      recentCustomers: recentCustomersList,
    );
  }
}