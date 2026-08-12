import '../../../../core/services/session_manager.dart';
import '../../domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileEntity> fetchProfile() async {
    final firstName = await SessionManager.getFirstName() ?? 'User';
    final lastName = await SessionManager.getLastName() ?? '';
    final mobileNo = await SessionManager.getMobileNo() ?? '';
    final emailID = await SessionManager.getEmailID() ?? '';
    final retailerCode = await SessionManager.getRetailerCode() ?? '';

    final Map<String, dynamic> jsonMap = {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'emailID': emailID,
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'kitBalance': 128,
      'totalKits': 200,
      'retailerCode': retailerCode,
    };

    return ProfileModel.fromJson(jsonMap);
  }
}