import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import '../../../history/presentation/viewmodels/history_viewmodel.dart';
import '../../data/analysis_repository.dart';
import '../../domain/product_analysis.dart';

/// Loads one saved analysis by id (used by history taps and post-scan).
class AnalysisDetailViewModel extends AsyncNotifier<ProductAnalysis> {
  AnalysisDetailViewModel(this.analysisId);

  final String analysisId;

  @override
  Future<ProductAnalysis> build() =>
      ref.watch(analysisRepositoryProvider).getById(analysisId);

  Future<void> toggleFavorite() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(favorite: !current.favorite));
    try {
      final updated = await ref
          .read(analysisRepositoryProvider)
          .toggleFavorite(analysisId);
      state = AsyncData(updated);
    } catch (_) {
      state = AsyncData(current);
      rethrow;
    }
  }
}

final analysisDetailProvider = AsyncNotifierProvider.family<
    AnalysisDetailViewModel, ProductAnalysis, String>(
  AnalysisDetailViewModel.new,
);

/// Submits a reviewed OCR result to the analysis engine. On success the
/// dashboard and history refresh automatically.
class AnalyzeSubmitViewModel extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<ProductAnalysis?> submit({
    String? productName,
    String? brand,
    String? rawText,
    required List<String> ingredients,
  }) async {
    state = const AsyncLoading();
    try {
      final analysis = await ref.read(analysisRepositoryProvider).analyze(
            productName: productName,
            brand: brand,
            rawText: rawText,
            ingredients: ingredients,
          );
      ref.invalidate(dashboardViewModelProvider);
      ref.invalidate(historyViewModelProvider);
      state = const AsyncData(null);
      return analysis;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }
}

final analyzeSubmitProvider =
    AsyncNotifierProvider.autoDispose<AnalyzeSubmitViewModel, void>(
  AnalyzeSubmitViewModel.new,
);

/// Compares two saved analyses server-side.
class CompareViewModel extends AsyncNotifier<ComparisonResult> {
  CompareViewModel(this.ids);

  final (String, String) ids;

  @override
  Future<ComparisonResult> build() =>
      ref.watch(analysisRepositoryProvider).compare(ids.$1, ids.$2);
}

final compareProvider = AsyncNotifierProvider.family<CompareViewModel,
    ComparisonResult, (String, String)>(CompareViewModel.new);
