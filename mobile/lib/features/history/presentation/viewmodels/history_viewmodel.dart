import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/history_repository.dart';
import '../../domain/analysis_summary.dart';

class HistoryViewModel extends AsyncNotifier<List<AnalysisSummary>> {
  @override
  Future<List<AnalysisSummary>> build() =>
      ref.watch(historyRepositoryProvider).fetchHistory();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(historyRepositoryProvider).fetchHistory(),
    );
  }
}

final historyViewModelProvider =
    AsyncNotifierProvider<HistoryViewModel, List<AnalysisSummary>>(
  HistoryViewModel.new,
);
