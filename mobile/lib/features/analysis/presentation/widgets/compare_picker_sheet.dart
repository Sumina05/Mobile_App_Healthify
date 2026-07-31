import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_date_format.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/score_ring.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../history/presentation/viewmodels/history_viewmodel.dart';
import '../../domain/product_analysis.dart';

/// Lets the user pick a second saved analysis to compare against.
void showComparePickerSheet(BuildContext context, ProductAnalysis current) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ComparePickerSheet(current: current),
  );
}

class _ComparePickerSheet extends ConsumerWidget {
  const _ComparePickerSheet({required this.current});

  final ProductAnalysis current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final history = ref.watch(historyViewModelProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        final items = (history.value ?? [])
            .where((a) => a.id != current.id)
            .toList();

        if (history.isLoading) return AppLoader.fullscreen();
        if (items.isEmpty) {
          return const StatusView.empty(
            title: 'Nothing to compare yet',
            message:
                'Scan another product first, then compare the two results side by side.',
          );
        }

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          children: [
            Text('Compare With…', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Pick a previous scan to compare against ${current.productName}.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.base),
            ...items.map(
              (analysis) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Card(
                  child: ListTile(
                    onTap: () {
                      // Grab the router before popping — the sheet's
                      // context is unusable once it is dismissed.
                      final router = GoRouter.of(context);
                      Navigator.of(context).pop();
                      router.push('/compare/${current.id}/${analysis.id}');
                    },
                    leading: ScoreRing(
                      score: analysis.score,
                      size: 44,
                      strokeWidth: 4,
                    ),
                    title: Text(
                      analysis.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${analysis.verdict} · '
                      '${AppDateFormat.relative(analysis.createdAt)}',
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
