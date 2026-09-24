import '../../domain/entities/qr_user_entity.dart';

class QrUserModel extends QrUserEntity {
  const QrUserModel({
    required super.userName,
    required super.profileImageUrl,
    required super.qrData,
  });

  factory QrUserModel.fromJson(Map<String, dynamic> json) {
    return QrUserModel(
      userName: json['userName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      qrData: json['qrData'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'qrData': qrData,
    };
  }
}