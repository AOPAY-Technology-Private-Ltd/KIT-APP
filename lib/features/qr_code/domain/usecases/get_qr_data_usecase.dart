import '../../domain/entities/qr_user_entity.dart';
import '../../domain/repositories/qr_repository.dart';

class GetQrDataUseCase {
  final QrRepository repository;

  GetQrDataUseCase(this.repository);

  Future<QrUserEntity> call() async {
    return await repository.getQrData();
  }
}