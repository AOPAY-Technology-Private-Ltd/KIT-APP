import '../../data/models/save_purchase_history_request_model.dart';
import '../repositories/buy_kits_repository.dart';

class SavePurchaseHistoryUseCase {
  final BuyKitsRepository repository;

  SavePurchaseHistoryUseCase(this.repository);

  Future<Map<String, dynamic>> execute(SavePurchaseHistoryRequestModel requestModel) async {
    return await repository.savePurchaseHistory(requestModel);
  }
}