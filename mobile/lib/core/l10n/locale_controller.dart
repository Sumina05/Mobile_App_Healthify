import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/app_providers.dart';

/// Persists and exposes the user's language choice. `null` follows the
/// device locale (falling back to English if the device isn't Nepali);
/// an explicit choice always overrides it, mirroring [ThemeModeController].
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(preferencesServiceProvider).languageCode;
    return code == null ? null : Locale(code);
  }

  Future<void> setLanguageCode(String? code) async {
    state = code == null ? null : Locale(code);
    await ref.read(preferencesServiceProvider).setLanguageCode(code);
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);
