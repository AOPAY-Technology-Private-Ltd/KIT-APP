import '../../domain/entities/qr_user_entity.dart';

abstract class QrRepository {
  Future<QrUserEntity> getQrData();
}