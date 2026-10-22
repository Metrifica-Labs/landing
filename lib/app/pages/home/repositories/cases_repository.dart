import 'package:metrifica_landing/app/core/providers/api_client_provider.dart';
import 'package:metrifica_landing/app/pages/home/models/case_model.dart';

class CasesRepository {
  const CasesRepository(this._api);

  final ApiClient _api;

  Future<List<CaseModel>> fetchCases() async {
    final response = await _api.get('/cases');
    return (response as List)
        .map((json) => CaseModel.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
