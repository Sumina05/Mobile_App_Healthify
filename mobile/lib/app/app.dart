import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/locale_controller.dart';
import '../core/storage/preferences_service.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../features/auth/presentation/viewmodels/auth_controller.dart';
import '../features/startup/presentation/viewmodels/splash_viewmodel.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';

/// A background stint shorter than this is treated as a transient system
/// interruption (e.g. the biometric prompt's own dialog briefly pausing the
/// activity) rather than the user actually leaving the app, so it does not
/// re-arm the splash/lock gate.
const _minBackgroundedDurationToRelock = Duration(seconds: 2);

class HealthifyApp extends ConsumerStatefulWidget {
  const HealthifyApp({super.key});

  @override
  ConsumerState<HealthifyApp> createState() => _HealthifyAppState();
}

class _HealthifyAppState extends ConsumerState<HealthifyApp>
    with WidgetsBindingObserver {
  DateTime? _pausedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _pausedAt ??= clock.now();
      case AppLifecycleState.resumed:
        final pausedAt = _pausedAt;
        _pausedAt = null;
        if (pausedAt == null) return;
        if (clock.now().difference(pausedAt) <
            _minBackgroundedDurationToRelock) {
          return;
        }
        // A real return to the app after being backgrounded: Android often
        // keeps the process (and every Riverpod provider) alive across this,
        // so without an explicit reset the app would just resume whatever
        // screen was last shown — skipping the splash and the biometric
        // re-check that a fresh launch is supposed to go through.
        ref.read(authControllerProvider.notifier).lockForResume();
        if (ref.read(authControllerProvider) is AuthUnknown) {
          ref.invalidate(splashViewModelProvider);
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    // Null means "follow the device locale"; MaterialApp does that itself
    // when `locale` is left null, as long as the device's language is one
    // AppLocalizations.delegate actually supports.
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'Healthify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: PreferencesService.supportedLanguageCodes
          .map(Locale.new),
      routerConfig: router,
    );
  }
}
