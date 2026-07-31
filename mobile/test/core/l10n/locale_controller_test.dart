import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/di/app_providers.dart';
import 'package:healthify_mobile/core/l10n/locale_controller.dart';
import 'package:healthify_mobile/core/storage/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> makeContainer({
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sharedPrefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
  );
  return container;
}

void main() {
  test('defaults to null (device locale) with nothing stored', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider), isNull);
  });

  test('restores a previously saved language on startup', () async {
    final container = await makeContainer(
      prefs: {'settings.languageCode': 'ne'},
    );
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider), const Locale('ne'));
  });

  test('setLanguageCode updates state immediately', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .setLanguageCode('ne');

    expect(container.read(localeControllerProvider), const Locale('ne'));
  });

  test('setLanguageCode persists across a fresh container (app restart)',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final first = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    await first
        .read(localeControllerProvider.notifier)
        .setLanguageCode('ne');
    first.dispose();

    // A new container simulates a fresh app process reading the same prefs.
    final second = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(second.dispose);

    expect(second.read(localeControllerProvider), const Locale('ne'));
  });

  test('passing null reverts to following the device locale', () async {
    final container = await makeContainer(
      prefs: {'settings.languageCode': 'ne'},
    );
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .setLanguageCode(null);

    expect(container.read(localeControllerProvider), isNull);
    final prefsService = PreferencesService(
      await SharedPreferences.getInstance(),
    );
    expect(prefsService.languageCode, isNull);
  });

  test('an unsupported stored code is ignored rather than crashing',
      () async {
    // Simulates a stale/corrupted value from an older build.
    final container = await makeContainer(
      prefs: {'settings.languageCode': 'fr'},
    );
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider), isNull);
  });
}
