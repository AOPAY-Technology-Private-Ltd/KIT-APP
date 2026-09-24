import '../repositories/support_repository.dart';

class GetSupportData {
  final SupportRepository repository;

  GetSupportData(this.repository);

  Future<Map<String, dynamic>> call() async {
    final faqs = await repository.getFaqs();
    final info = await repository.getSupportDetails();
    return {'faqs': faqs, 'info': info};
  }
}