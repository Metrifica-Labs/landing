import 'package:metrifica_landing/app/pages/home/models/case_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CasesRepository {
  const CasesRepository(this._client);

  final SupabaseClient _client;

  Future<List<CaseModel>> fetchCases() async {
    final response = await _client
        .from('cases')
        .select()
        .eq('published', true)
        .order('order', ascending: true);

    return (response as List)
        .map((json) => CaseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
