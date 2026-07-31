import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dashboard_repository.dart';
import '../../domain/dashboard_data.dart';

class DashboardViewModel extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() =>
      ref.watch(dashboardRepositoryProvider).fetch();

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(dashboardRepositoryProvider).fetch(),
    );
  }
}

final dashboardViewModelProvider =
    AsyncNotifierProvider<DashboardViewModel, DashboardData>(
  DashboardViewModel.new,
);
