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

    return (response as List).map((json) {
      final map = Map<String, dynamic>.from(json as Map);
      map['image_url'] = _resolveUrl(map['image_url'] as String?);
      map['images'] = (map['images'] as List<dynamic>? ?? [])
          .map((e) => _resolveUrl(e as String?) ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
      return CaseModel.fromJson(map);
    }).toList();
  }

  // Accepts either a bare storage path ("thumbnail.jpg") or a full URL (pass-through).
  String? _resolveUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.isEmpty) return null;
    if (pathOrUrl.startsWith('http')) return pathOrUrl;
    return _client.storage.from('cases').getPublicUrl(pathOrUrl);
  }
}
