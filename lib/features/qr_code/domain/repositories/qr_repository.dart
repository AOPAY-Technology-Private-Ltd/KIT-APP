import '../entities/qr_user_entity.dart';

abstract class QrRepository {
  Future<QrUserEntity> validateKey({required String apiKey});
  Future<QrUserEntity> fetchQrData();
}