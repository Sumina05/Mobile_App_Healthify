import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_date_format.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/score_ring.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../history/domain/analysis_summary.dart';
import '../../../ingredients/domain/ingredient.dart';
import '../../../ingredients/presentation/widgets/ingredient_detail_sheet.dart';
import '../../domain/dashboard_data.dart';
import '../viewmodels/dashboard_viewmodel.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: switch (state) {
          AsyncValue(:final value?) => _DashboardBody(data: value),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
            error,
            fallbackMessage: 'Could not load your dashboard.',
            onRetry: () =>
                ref.read(dashboardViewModelProvider.notifier).refresh(),
          ),
          _ => AppLoader.fullscreen(),
        },
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.data});

  final DashboardData data;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final firstName = data.user.name.split(' ').first;

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        children: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_greeting, $firstName! 👋',
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      "Here's your skin health overview",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push(RoutePaths.search),
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Search ingredients & products',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _NotificationBell(unread: data.unreadNotifications),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SkinScoreCard(score: data.skinScore, stats: data.weeklyStats),
          SectionHeader(title: 'Quick Actions'),
          const _QuickActions(),
          SectionHeader(title: "Today's Insight"),
          _InsightCard(insight: data.todayInsight),
          if (data.todayIngredient != null) ...[
            SectionHeader(
              title: "Today's Ingredient",
              actionLabel: 'Browse all',
              onAction: () => context.push(RoutePaths.ingredients),
            ),
            _TodayIngredientCard(ingredient: data.todayIngredient!),
          ],
          SectionHeader(
            title: 'Recommended For You',
            actionLabel: data.recommendations.isNotEmpty ? 'See all' : null,
            onAction: () => context.push(RoutePaths.ingredients),
          ),
          if (data.user.skinProfile == null)
            _CompleteProfileCard(
              onTap: () => context.push(RoutePaths.skinProfile),
            )
          else if (data.recommendations.isEmpty)
            const _EmptyHint(
              icon: Icons.auto_awesome_rounded,
              text:
                  'No matches yet — update your skin concerns to get tailored ingredients.',
            )
          else
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.recommendations.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _RecommendationCard(ingredient: data.recommendations[i]),
              ),
            ),
          SectionHeader(
            title: 'Recent Scans',
            actionLabel: data.recentAnalyses.isNotEmpty ? 'View all' : null,
            onAction: () => context.push(RoutePaths.history),
          ),
          if (data.recentAnalyses.isEmpty)
            _EmptyHint(
              icon: Icons.document_scanner_outlined,
              text:
                  'No scans yet. Scan your first product to see how it suits your skin.',
              actionLabel: 'Scan Now',
              onAction: () => context.push(RoutePaths.scanner),
            )
          else
            ...data.recentAnalyses.map(
              (analysis) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: AnalysisTile(analysis: analysis),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.unread});

  final int unread;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        IconButton(
          onPressed: () => context.push(RoutePaths.notifications),
          icon: const Icon(Icons.notifications_none_rounded),
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainer,
          ),
        ),
        if (unread > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$unread',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 9,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SkinScoreCard extends StatelessWidget {
  const _SkinScoreCard({required this.score, required this.stats});

  final int? score;
  final WeeklyStats stats;

  String _verdict(int s) {
    if (s >= 85) return 'Excellent';
    if (s >= 70) return 'Good';
    if (s >= 50) return 'Average';
    return 'Needs care';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overall Skin Score', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  score != null
                      ? '${_verdict(score!)} — keep it up!'
                      : 'Scan a product to unlock your score.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                // Wrap, not Row: two pills plus the score ring overflow a
                // narrow screen once the scan count reaches double digits,
                // and again at larger font scales.
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _StatPill(
                      icon: Icons.qr_code_scanner_rounded,
                      label: '${stats.scans} scans this week',
                    ),
                    if (stats.averageScore != null)
                      _StatPill(
                        icon: Icons.trending_up_rounded,
                        label: 'avg ${stats.averageScore}',
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          score != null
              ? ScoreRing(score: score!)
              : ScoreRing(
                  score: 0,
                  child: const Icon(
                    Icons.spa_rounded,
                    color: AppColors.mint,
                    size: 32,
                  ),
                ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    // History and Favorites are bottom-nav tabs, so the quick actions surface
    // the destinations that are otherwise buried instead of duplicating them.
    final actions = [
      (Icons.document_scanner_outlined, 'Scan', RoutePaths.scanner),
      (Icons.qr_code_scanner_rounded, 'Barcode', RoutePaths.barcodeScanner),
      (Icons.inventory_2_outlined, 'Products', RoutePaths.products),
      (Icons.smart_toy_outlined, 'Assistant', RoutePaths.chat),
    ];
    final theme = Theme.of(context);

    return Row(
      children: [
        for (final (icon, label, path) in actions)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => context.push(path),
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: label == 'Scan' ? AppGradients.primary : null,
                        color: label == 'Scan'
                            ? null
                            : theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: label == 'Scan'
                            ? null
                            : Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Icon(
                        icon,
                        color: label == 'Scan'
                            ? AppColors.onMint
                            : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(label, style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final DailyInsight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.tips_and_updates_rounded,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(insight.title, style: theme.textTheme.titleSmall),
                ),
                Chip(
                  label: Text(insight.tag),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(insight.body, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _TodayIngredientCard extends StatelessWidget {
  const _TodayIngredientCard({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => showIngredientDetail(context, ingredient),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppGradients.accent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(Icons.science_rounded, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ingredient.name, style: theme.textTheme.titleSmall),
                    Text(
                      ingredient.tagline,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 190,
      child: Card(
        child: InkWell(
          onTap: () => showIngredientDetail(context, ingredient),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: safetyColor(
                      ingredient.safetyRating,
                    ).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    safetyLabel(ingredient.safetyRating),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: safetyColor(ingredient.safetyRating),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  ingredient.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  ingredient.tagline,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompleteProfileCard extends StatelessWidget {
  const _CompleteProfileCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Icons.face_retouching_natural_rounded,
            color: AppColors.violet,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your skin profile',
                  style: theme.textTheme.titleSmall,
                ),
                Text(
                  'Unlock personalized recommendations and suitability scores.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.base),
            Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
            if (actionLabel != null)
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ),
      ),
    );
  }
}

/// Shared list row for a saved analysis (dashboard + history screens).
class AnalysisTile extends StatelessWidget {
  const AnalysisTile({super.key, required this.analysis});

  final AnalysisSummary analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => context.push('${RoutePaths.analysis}/${analysis.id}'),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ScoreRing(score: analysis.score, size: 52, strokeWidth: 5),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis.productName,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${analysis.verdict[0].toUpperCase()}${analysis.verdict.substring(1)}'
                      ' · ${AppDateFormat.relative(analysis.createdAt)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (analysis.warnings.isNotEmpty)
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
