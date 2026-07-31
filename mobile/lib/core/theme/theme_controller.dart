import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/app_providers.dart';

/// Persists and exposes the user's theme choice (dark is the default).
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.read(preferencesServiceProvider).themeMode;

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref.read(preferencesServiceProvider).setThemeMode(mode);
  }

  Future<void> toggle() =>
      setMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
