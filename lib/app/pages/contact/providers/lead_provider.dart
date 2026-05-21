import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:metrifica_landing/app/core/providers/supabase_provider.dart';

import '../models/lead_model.dart';
import '../repositories/lead_repository.dart';

final _leadRepositoryProvider = Provider<LeadRepository>((ref) {
  return LeadRepository(ref.watch(supabaseClientProvider));
});

class LeadState {
  const LeadState({
    this.draftId,
    this.asyncValue = const AsyncData(null),
  });

  final String? draftId;
  final AsyncValue<void> asyncValue;

  bool get hasError  => asyncValue.hasError;
  bool get isLoading => asyncValue.isLoading;

  LeadState copyWith({String? draftId, AsyncValue<void>? asyncValue}) =>
      LeadState(
        draftId:    draftId    ?? this.draftId,
        asyncValue: asyncValue ?? this.asyncValue,
      );
}

class LeadNotifier extends StateNotifier<LeadState> {
  LeadNotifier(this._repo) : super(const LeadState());

  final LeadRepository _repo;
  bool _saving = false;

  Future<void> saveDraft(LeadModel lead) async {
    if (_saving) return;
    if (state.draftId != null) {
      await updateDraft(lead);
      return;
    }
    _saving = true;
    state = state.copyWith(asyncValue: const AsyncLoading());
    final result = await AsyncValue.guard(() => _repo.saveDraft(lead));
    _saving = false;
    if (result is AsyncData<String>) {
      state = state.copyWith(
        draftId:    result.value,
        asyncValue: const AsyncData(null),
      );
    } else {
      state = state.copyWith(asyncValue: const AsyncData(null));
    }
  }

  Future<void> updateDraft(LeadModel lead) async {
    final id = state.draftId;
    if (id == null) return;
    _repo.updateDraft(id, lead).catchError((_) {});
  }

  Future<void> submit(LeadModel lead) async {
    final id = state.draftId;
    if (id == null) {
      state = state.copyWith(asyncValue: const AsyncLoading());
      final result = await AsyncValue.guard(
        () => _repo.saveDraft(lead.copyWith(status: 'completed')).then((_) {}),
      );
      state = state.copyWith(asyncValue: result);
      return;
    }
    state = state.copyWith(asyncValue: const AsyncLoading());
    state = state.copyWith(
      asyncValue: await AsyncValue.guard(() => _repo.submit(id, lead)),
    );
  }
}

final leadNotifierProvider =
    StateNotifierProvider<LeadNotifier, LeadState>((ref) {
  return LeadNotifier(ref.watch(_leadRepositoryProvider));
});
