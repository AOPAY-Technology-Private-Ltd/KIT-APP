import 'package:http/http.dart' as http;
import '../models/reference_model.dart';

abstract class ReferenceRemoteDataSource {
  Future<void> submitReference(ReferenceModel referenceModel);
}

class ReferenceRemoteDataSourceImpl implements ReferenceRemoteDataSource {
  final http.Client client;

  ReferenceRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitReference(ReferenceModel referenceModel) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}