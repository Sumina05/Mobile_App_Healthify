import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthify_mobile/core/di/app_providers.dart';
import 'package:healthify_mobile/core/l10n/locale_controller.dart';
import 'package:healthify_mobile/core/theme/app_theme.dart';
import 'package:healthify_mobile/features/settings/presentation/views/settings_view.dart';
import 'package:healthify_mobile/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpSettings(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sharedPrefs = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      // Mirrors app.dart: MaterialApp.locale must read the same provider
      // SettingsView's language picker writes to, or the picked language
      // updates the picker's own state without ever changing what
      // AppLocalizations.of(context) resolves to.
      child: Consumer(
        builder: (context, ref, _) => MaterialApp(
          theme: AppTheme.dark(),
          locale: ref.watch(localeControllerProvider),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ne')],
          home: const SettingsView(),
        ),
      ),
    ),
  );
  // The biometric-availability FutureProvider settles asynchronously.
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('SettingsView localization', () {
    testWidgets('renders in English by default', (tester) async {
      await pumpSettings(tester);

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('नेपाली'), findsOneWidget);
    });

    testWidgets('renders in Nepali when that language was saved',
        (tester) async {
      await pumpSettings(
        tester,
        prefs: {'settings.languageCode': 'ne'},
      );

      // The screen itself must have actually switched — this is the crux
      // of "switching languages updates the UI immediately".
      expect(find.text('सेटिङहरू'), findsOneWidget);
      expect(find.text('रूपरेखा'), findsOneWidget);
      expect(find.text('डार्क मोड'), findsOneWidget);
      expect(find.text('भाषा'), findsOneWidget);

      // English strings from the un-migrated part of the screen must not
      // still be showing under a Nepali locale.
      expect(find.text('Settings'), findsNothing);
      expect(find.text('Dark Mode'), findsNothing);
    });

    testWidgets('tapping Nepali switches the screen live, no restart',
        (tester) async {
      await pumpSettings(tester);
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('नेपाली'));
      await tester.pumpAndSettle();

      expect(find.text('सेटिङहरू'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('the chosen language persists into a fresh widget tree '
        '(app restart)', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              theme: AppTheme.dark(),
              locale: ref.watch(localeControllerProvider),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('ne')],
              home: const SettingsView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('नेपाली'));
      await tester.pumpAndSettle();
      expect(find.text('सेटिङहरू'), findsOneWidget);

      // A brand-new widget tree over the SAME SharedPreferences instance
      // simulates a cold app restart.
      await tester.pumpWidget(const SizedBox.shrink());
      await pumpSettings(tester, prefs: {'settings.languageCode': 'ne'});

      expect(find.text('सेटिङहरू'), findsOneWidget);
    });
  });
}
