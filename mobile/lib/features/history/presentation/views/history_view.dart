import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../dashboard/presentation/views/dashboard_view.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: SafeArea(
        child: switch (state) {
          AsyncValue(:final value?) when value.isEmpty => StatusView.empty(
              title: 'No scans yet',
              message:
                  'Products you analyze will appear here with their scores.',
              retryLabel: 'Scan a Product',
              onRetry: () => context.push(RoutePaths.scanner),
            ),
          AsyncValue(:final value?) => RefreshIndicator(
              onRefresh: () =>
                  ref.read(historyViewModelProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screen),
                itemCount: value.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) => AnalysisTile(analysis: value[i]),
              ),
            ),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
              error,
              fallbackMessage: 'Could not load your history.',
              onRetry: () =>
                  ref.read(historyViewModelProvider.notifier).refresh(),
            ),
          _ => const SkeletonList(),
        },
      ),
    );
  }
}
