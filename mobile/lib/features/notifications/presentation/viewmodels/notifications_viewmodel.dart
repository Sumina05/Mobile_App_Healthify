import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/notifications_repository.dart';
import '../../domain/app_notification.dart';

typedef NotificationsState = ({List<AppNotification> items, int unread});

class NotificationsViewModel extends AsyncNotifier<NotificationsState> {
  @override
  Future<NotificationsState> build() =>
      ref.watch(notificationsRepositoryProvider).fetchAll();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(notificationsRepositoryProvider).fetchAll(),
    );
  }

  Future<void> markRead(AppNotification notification) async {
    if (notification.read) return;
    await ref.read(notificationsRepositoryProvider).markRead(notification.id);
    await refresh();
  }

  Future<void> markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    await refresh();
  }
}

final notificationsViewModelProvider =
    AsyncNotifierProvider<NotificationsViewModel, NotificationsState>(
  NotificationsViewModel.new,
);
