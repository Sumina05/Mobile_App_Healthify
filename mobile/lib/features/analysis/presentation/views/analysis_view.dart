import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/score_ring.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../ingredients/data/ingredients_repository.dart';
import '../../../ingredients/presentation/widgets/ingredient_detail_sheet.dart';
import '../../domain/product_analysis.dart';
import '../viewmodels/analysis_viewmodels.dart';
import '../widgets/compare_picker_sheet.dart';

Color statusColor(String status) => switch (status) {
      'good' => AppColors.success,
      'caution' => AppColors.warning,
      'avoid' || 'allergy' => AppColors.danger,
      _ => AppColors.info,
    };

String statusLabel(String status) => switch (status) {
      'good' => 'Good',
      'caution' => 'Watch',
      'avoid' => 'Avoid',
      'allergy' => 'Allergy',
      _ => 'Neutral',
    };

class AnalysisView extends ConsumerWidget {
  const AnalysisView({super.key, required this.analysisId});

  final String analysisId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisDetailProvider(analysisId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
        actions: [
          if (state.value != null) ...[
            IconButton(
              onPressed: () async {
                try {
                  await ref
                      .read(analysisDetailProvider(analysisId).notifier)
                      .toggleFavorite();
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not update bookmark')),
                    );
                  }
                }
              },
              icon: Icon(
                state.value!.favorite
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: state.value!.favorite ? AppColors.mint : null,
              ),
            ),
            IconButton(
              onPressed: () => _share(state.value!),
              icon: const Icon(Icons.ios_share_rounded),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: switch (state) {
          AsyncValue(:final value?) => _AnalysisBody(analysis: value),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
              error,
              fallbackMessage: 'Could not load this analysis.',
              onRetry: () =>
                  ref.invalidate(analysisDetailProvider(analysisId)),
            ),
          _ => AppLoader.fullscreen(),
        },
      ),
    );
  }

  Future<void> _share(ProductAnalysis analysis) {
    final text = StringBuffer()
      ..writeln('${analysis.productName} — Healthify Analysis')
      ..writeln(
          'Suitability Score: ${analysis.score}/100 (${analysis.verdict})')
      ..writeln(analysis.summary)
      ..writeln()
      ..writeln(analysis.recommendationReason);
    return SharePlus.instance
        .share(ShareParams(text: text.toString().trim()));
  }
}

class _AnalysisBody extends ConsumerWidget {
  const _AnalysisBody({required this.analysis});

  final ProductAnalysis analysis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final safetyLabelText = switch (analysis.safetyRating) {
      'low_risk' => 'Low Risk',
      'moderate_risk' => 'Moderate Risk',
      _ => 'High Risk',
    };
    final safetyColorValue = switch (analysis.safetyRating) {
      'low_risk' => AppColors.success,
      'moderate_risk' => AppColors.warning,
      _ => AppColors.danger,
    };

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            children: [
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      analysis.productName,
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (analysis.brand != null)
                      Text(analysis.brand!,
                          style: theme.textTheme.bodySmall),
                    const SizedBox(height: AppSpacing.lg),
                    ScoreRing(score: analysis.score, size: 140, strokeWidth: 11),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Product Suitability Score',
                      style: theme.textTheme.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            '${analysis.verdict[0].toUpperCase()}${analysis.verdict.substring(1)} Match',
                          ),
                          avatar: const Icon(Icons.verified_rounded,
                              size: 16, color: AppColors.mint),
                        ),
                        Chip(
                          label: Text(safetyLabelText),
                          avatar: Icon(Icons.shield_outlined,
                              size: 16, color: safetyColorValue),
                          side: BorderSide(
                            color: safetyColorValue.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SectionHeader(title: 'Key Highlights'),
              Row(
                children: [
                  _HighlightPill(
                    label: 'Beneficial',
                    value: analysis.goodCount,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _HighlightPill(
                    label: 'To Watch',
                    value: analysis.watchCount,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _HighlightPill(
                    label: 'Warnings',
                    value: analysis.warnings.length,
                    color: AppColors.danger,
                  ),
                ],
              ),
              if (analysis.warnings.isNotEmpty) ...[
                const SectionHeader(title: 'Warnings'),
                ...analysis.warnings.map(
                  (warning) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        side: BorderSide(
                          color: AppColors.danger.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.base),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: AppColors.danger),
                            const SizedBox(width: AppSpacing.base),
                            Expanded(
                              child: Text(warning,
                                  style: theme.textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SectionHeader(title: 'Why This Score'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_rounded,
                              color: AppColors.violet, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text('AI Recommendation',
                              style: theme.textTheme.titleSmall),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(analysis.recommendationReason,
                          style: theme.textTheme.bodyMedium),
                      if (analysis.aiExplanation.isNotEmpty) ...[
                        const Divider(height: AppSpacing.lg),
                        Text(analysis.aiExplanation,
                            style: theme.textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
              ),
              SectionHeader(
                title:
                    'Ingredient Breakdown (${analysis.breakdown.length})',
              ),
              ...analysis.breakdown.map(
                (entry) => _BreakdownTile(entry: entry),
              ),
              if (analysis.alternatives.isNotEmpty) ...[
                const SectionHeader(title: 'Better Alternatives For You'),
                ...analysis.alternatives.map(
                  (alt) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius:
                                BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(Icons.recommend_rounded,
                              color: AppColors.onMint, size: 22),
                        ),
                        title: Text(alt.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${alt.brand} · ${alt.category}'),
                        trailing: Text(
                          '${alt.matchPercent}%\nMatch',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: AppColors.mint),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.sm,
            AppSpacing.screen,
            AppSpacing.base,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      showComparePickerSheet(context, analysis),
                  icon: const Icon(Icons.compare_arrows_rounded),
                  label: const Text('Compare'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GradientButton(
                  label: 'Ask AI',
                  icon: Icons.smart_toy_outlined,
                  onPressed: () => context.push(
                    RoutePaths.chat,
                    extra: {
                      'analysisId': analysis.id,
                      'productName': analysis.productName,
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HighlightPill extends StatelessWidget {
  const _HighlightPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          children: [
            Text('$value',
                style: theme.textTheme.titleLarge?.copyWith(color: color)),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _BreakdownTile extends ConsumerWidget {
  const _BreakdownTile({required this.entry});

  final BreakdownEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = statusColor(entry.status);

    Future<void> openDetail() async {
      if (entry.ingredientId == null) return;
      try {
        final ingredient = await ref
            .read(ingredientsRepositoryProvider)
            .getById(entry.ingredientId!);
        if (context.mounted) showIngredientDetail(context, ingredient);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not load ingredient')),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: ListTile(
          onTap: entry.ingredientId != null ? openDetail : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.xs,
          ),
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              switch (entry.status) {
                'good' => Icons.check_rounded,
                'caution' => Icons.priority_high_rounded,
                'avoid' || 'allergy' => Icons.close_rounded,
                _ => Icons.remove_rounded,
              },
              color: color,
              size: 20,
            ),
          ),
          title: Text(entry.name, style: theme.textTheme.titleSmall),
          subtitle: Text(entry.reason, style: theme.textTheme.bodySmall),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              statusLabel(entry.status),
              style: theme.textTheme.labelSmall?.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
