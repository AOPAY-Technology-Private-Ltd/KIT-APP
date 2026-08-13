import '../models/qr_user_model.dart';

abstract class QrRemoteDataSource {
  Future<QrUserModel> fetchQrData();
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  @override
  Future<QrUserModel> fetchQrData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const QrUserModel(
      userName: 'Pinki Sethi',
      profileImageUrl: '',
      qrData: 'https://dpcapp.com/download',
    );
  }
}