import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/lead_model.dart';

class LeadRepository {
  const LeadRepository(this._client);

  final SupabaseClient _client;

  Future<void> submit(LeadModel lead) async {
    await _client.from('leads').insert(lead.toJson());
  }
}
