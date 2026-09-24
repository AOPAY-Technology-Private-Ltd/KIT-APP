import '../../domain/entities/qr_user_entity.dart';
import '../../domain/repositories/qr_repository.dart';

class GetQrDataUseCase {
  final QrRepository repository;

  GetQrDataUseCase(this.repository);
  Future<QrUserEntity> validateKey({required String apiKey}) async {
    return await repository.validateKey(apiKey: apiKey);
  }
  Future<QrUserEntity> fetchIosQrData() async {
    return await repository.fetchQrData();
  }
}