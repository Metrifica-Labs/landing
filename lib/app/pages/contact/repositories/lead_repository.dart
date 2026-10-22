import 'package:metrifica_landing/app/core/providers/api_client_provider.dart';

import '../models/lead_model.dart';

class LeadRepository {
  const LeadRepository(this._api);

  final ApiClient _api;

  Future<String> saveDraft(LeadModel lead) async {
    final res = await _api.post('/leads', lead.toJson());
    return res['id'] as String;
  }

  Future<void> updateDraft(String id, LeadModel lead) async {
    await _api.patch('/leads/$id', lead.toJson());
  }

  Future<void> submit(String id, LeadModel lead) async {
    await _api.patch('/leads/$id', {...lead.toJson(), 'status': 'completed'});
  }
}
