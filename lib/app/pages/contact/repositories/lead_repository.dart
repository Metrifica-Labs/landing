import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/lead_model.dart';

class LeadRepository {
  const LeadRepository(this._client);

  final SupabaseClient _client;

  Future<String> saveDraft(LeadModel lead) async {
    final res = await _client
        .from('leads')
        .insert(lead.toJson())
        .select('id')
        .single();
    return res['id'] as String;
  }

  Future<void> updateDraft(String id, LeadModel lead) async {
    await _client.from('leads').update(lead.toJson()).eq('id', id);
  }

  Future<void> submit(String id, LeadModel lead) async {
    await _client
        .from('leads')
        .update({...lead.toJson(), 'status': 'completed'})
        .eq('id', id);
  }
}
