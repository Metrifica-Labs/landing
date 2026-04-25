import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrifica_landing/app/core/providers/supabase_provider.dart';
import 'package:metrifica_landing/app/pages/home/models/case_model.dart';
import 'package:metrifica_landing/app/pages/home/repositories/cases_repository.dart';

final casesRepositoryProvider = Provider<CasesRepository>((ref) {
  return CasesRepository(ref.read(supabaseClientProvider));
});

final casesProvider = FutureProvider<List<CaseModel>>((ref) {
  return ref.read(casesRepositoryProvider).fetchCases();
});
