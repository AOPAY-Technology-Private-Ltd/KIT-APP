import 'package:http/http.dart' as http;
import '../models/support_model.dart';

abstract class SupportRemoteDataSource {
  Future<List<FaqModel>> fetchFaqs();
  Future<SupportInfoModel> fetchSupportDetails();
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final http.Client client;

  SupportRemoteDataSourceImpl({required this.client});

  @override
  Future<List<FaqModel>> fetchFaqs() async {
    await Future.delayed(const Duration(seconds: 1));
    return const [
      FaqModel(
        id: '1',
        question: 'How to reset my password?',
        answer: 'You can reset your password from the login screen by clicking on Forgot Password.',
      ),
      FaqModel(
        id: '2',
        question: 'How to contact customer care?',
        answer: 'You can directly call us or chat via WhatsApp using the buttons above.',
      ),
      FaqModel(
        id: '3',
        question: 'How to add a new device?',
        answer: 'Go to the device list section and tap on the add (+) button to register your device.',
      ),
    ];
  }

  @override
  Future<SupportInfoModel> fetchSupportDetails() async {
    await Future.delayed(const Duration(seconds: 1));

    return const SupportInfoModel(
      phone: '+91 9876543210',
      whatsapp: '+91 9876543210',
      email: 'support@logkit.com',
    );
  }
}