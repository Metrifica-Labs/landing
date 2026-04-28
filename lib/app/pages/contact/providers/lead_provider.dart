import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:metrifica_landing/app/core/providers/supabase_provider.dart';

import '../models/lead_model.dart';
import '../repositories/lead_repository.dart';

final _leadRepositoryProvider = Provider<LeadRepository>((ref) {
  return LeadRepository(ref.watch(supabaseClientProvider));
});

class _LeadNotifier extends StateNotifier<AsyncValue<void>> {
  _LeadNotifier(this._repo) : super(const AsyncData(null));

  final LeadRepository _repo;

  Future<void> submit(LeadModel lead) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.submit(lead));
  }
}

final leadNotifierProvider =
    StateNotifierProvider<_LeadNotifier, AsyncValue<void>>((ref) {
  return _LeadNotifier(ref.watch(_leadRepositoryProvider));
});
