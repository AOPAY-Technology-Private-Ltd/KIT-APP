import '../../domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileEntity> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const ProfileEntity(
      name: 'Pinki Sethi',
      phone: '+91 8377847722',
      email: 'psaloopyaaz@gmail.com',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      kitBalance: 128,
      totalKits: 200,
    );
  }
}