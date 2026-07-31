import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_date_format.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_view.dart';
import '../../domain/app_notification.dart';
import '../viewmodels/notifications_viewmodel.dart';

IconData _iconFor(String type) => switch (type) {
      'welcome' => Icons.spa_rounded,
      'tip' => Icons.tips_and_updates_rounded,
      'reminder' => Icons.alarm_rounded,
      'recommendation' => Icons.auto_awesome_rounded,
      _ => Icons.notifications_rounded,
    };

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if ((state.value?.unread ?? 0) > 0)
            TextButton(
              onPressed: () => ref
                  .read(notificationsViewModelProvider.notifier)
                  .markAllRead(),
              child: const Text('Mark all as read'),
            ),
        ],
      ),
      body: SafeArea(
        child: switch (state) {
          AsyncValue(:final value?) when value.items.isEmpty =>
            const StatusView.empty(
              title: 'All caught up',
              message: 'Tips, reminders, and updates will land here.',
            ),
          AsyncValue(:final value?) => RefreshIndicator(
              onRefresh: () =>
                  ref.read(notificationsViewModelProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screen),
                itemCount: value.items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) =>
                    _NotificationTile(notification: value.items[i]),
              ),
            ),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
              error,
              fallbackMessage: 'Could not load notifications.',
              onRetry: () =>
                  ref.read(notificationsViewModelProvider.notifier).refresh(),
            ),
          _ => const SkeletonList(),
        },
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});

  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        onTap: () => ref
            .read(notificationsViewModelProvider.notifier)
            .markRead(notification),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.xs,
        ),
        leading: CircleAvatar(
          backgroundColor:
              theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(
            _iconFor(notification.type),
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight:
                notification.read ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body, style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppDateFormat.relative(notification.createdAt),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: notification.read
            ? null
            : const CircleAvatar(
                radius: 4,
                backgroundColor: AppColors.mint,
              ),
      ),
    );
  }
}
