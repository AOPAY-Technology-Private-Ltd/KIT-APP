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
    return ProfileModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
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