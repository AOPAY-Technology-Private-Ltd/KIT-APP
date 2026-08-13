import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.phone,
    required super.email,
    required super.avatarUrl,
    required super.kitBalance,
    required super.totalKits,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String fName = json['firstName'] ?? '';
    String lName = json['lastName'] ?? '';
    String fullName = '$fName $lName'.trim();

    return ProfileModel(
      name: fullName.isNotEmpty ? fullName : 'User',
      phone: json['mobileNo'] ?? '',
      email: json['emailID'] ?? '',
      avatarUrl: json['avatarUrl'] ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      kitBalance: json['kitBalance'] ?? 0,
      totalKits: json['totalKits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'avatarUrl': avatarUrl,
      'kitBalance': kitBalance,
      'totalKits': totalKits,
    };
  }
}