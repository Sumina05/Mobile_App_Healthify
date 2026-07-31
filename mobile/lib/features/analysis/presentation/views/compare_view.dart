import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/score_ring.dart';
import '../../../../core/widgets/status_view.dart';
import '../../domain/product_analysis.dart';
import '../viewmodels/analysis_viewmodels.dart';

class CompareView extends ConsumerWidget {
  const CompareView({super.key, required this.idA, required this.idB});

  final String idA;
  final String idB;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(compareProvider((idA, idB)));

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Products')),
      body: SafeArea(
        child: switch (state) {
          AsyncValue(:final value?) => _CompareBody(result: value),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
              error,
              fallbackMessage: 'Could not compare these analyses.',
              onRetry: () => ref.invalidate(compareProvider((idA, idB))),
            ),
          _ => AppLoader.fullscreen(),
        },
      ),
    );
  }
}

class _CompareBody extends StatelessWidget {
  const _CompareBody({required this.result});

  final ComparisonResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = result.a;
    final b = result.b;
    final winner = result.winner == null
        ? null
        : result.winner == a.id
            ? a
            : b;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _ProductColumn(analysis: a)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxl,
              ),
              child: Text('VS',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: AppColors.violet)),
            ),
            Expanded(child: _ProductColumn(analysis: b)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (winner != null)
          GlassCard(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.emoji_events_rounded,
                      color: AppColors.onMint),
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Better match for you',
                          style: theme.textTheme.labelMedium),
                      Text(winner.productName,
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.balance_rounded, color: AppColors.info),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Text("It's a tie — both products scored equally.",
                      style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        _MetricRow(
          label: 'Suitability Score',
          a: '${a.score}',
          b: '${b.score}',
          aWins: a.score > b.score,
          bWins: b.score > a.score,
        ),
        _MetricRow(
          label: 'Beneficial Ingredients',
          a: '${a.goodCount}',
          b: '${b.goodCount}',
          aWins: a.goodCount > b.goodCount,
          bWins: b.goodCount > a.goodCount,
        ),
        _MetricRow(
          label: 'Ingredients to Watch',
          a: '${a.watchCount}',
          b: '${b.watchCount}',
          aWins: a.watchCount < b.watchCount,
          bWins: b.watchCount < a.watchCount,
        ),
        _MetricRow(
          label: 'Warnings',
          a: '${a.warnings.length}',
          b: '${b.warnings.length}',
          aWins: a.warnings.length < b.warnings.length,
          bWins: b.warnings.length < a.warnings.length,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/analysis/${a.id}'),
                child: Text('View ${_short(a.productName)}',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/analysis/${b.id}'),
                child: Text('View ${_short(b.productName)}',
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _short(String name) =>
      name.length > 14 ? '${name.substring(0, 14)}…' : name;
}

class _ProductColumn extends StatelessWidget {
  const _ProductColumn({required this.analysis});

  final ProductAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          children: [
            ScoreRing(score: analysis.score, size: 80, strokeWidth: 7),
            const SizedBox(height: AppSpacing.md),
            Text(
              analysis.productName,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (analysis.brand != null)
              Text(analysis.brand!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSpacing.xs),
            Text(
              analysis.verdict.toUpperCase(),
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.a,
    required this.b,
    required this.aWins,
    required this.bWins,
  });

  final String label;
  final String a;
  final String b;
  final bool aWins;
  final bool bWins;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget value(String text, bool wins) {
      return Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: wins
              ? AppColors.success.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            color: wins ? AppColors.success : null,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              value(a, aWins),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium,
                ),
              ),
              value(b, bWins),
            ],
          ),
        ),
      ),
    );
  }
}
