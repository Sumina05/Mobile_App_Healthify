import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/di/app_providers.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/local_notification_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../l10n/generated/app_localizations.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  late bool _biometricEnabled =
      ref.read(preferencesServiceProvider).biometricEnabled;
  late bool _scanReminders =
      ref.read(preferencesServiceProvider).scanRemindersEnabled;

  Future<void> _toggleBiometric(bool enable) async {
    final l10n = AppLocalizations.of(context);
    final prefs = ref.read(preferencesServiceProvider);
    final biometrics = ref.read(biometricServiceProvider);

    if (enable) {
      if (!await biometrics.isSupported()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.settingsBiometricNotSupportedSnackbar)),
          );
        }
        return;
      }
      final ok = await biometrics.authenticate(
        reason: 'Confirm to enable biometric login',
      );
      if (!ok) return;
    }

    await prefs.setBiometricEnabled(enable);
    if (mounted) setState(() => _biometricEnabled = enable);
  }

  Future<void> _pickLanguage(String? code) async {
    await ref.read(localeControllerProvider.notifier).setLanguageCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final version = ref.watch(appVersionProvider).value;
    final languageCode = ref.watch(localeControllerProvider)?.languageCode;
    // Unknown (still probing) counts as unavailable so the switch never
    // flickers into an enabled state it cannot honour.
    final biometricsAvailable =
        ref.watch(biometricAvailableProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text(l10n.settingsSectionAppearance,
                style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: Text(l10n.settingsDarkMode),
                    value: themeMode != ThemeMode.light,
                    onChanged: (dark) => ref
                        .read(themeModeProvider.notifier)
                        .setMode(dark ? ThemeMode.dark : ThemeMode.light),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.settingsSectionLanguage,
                style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: RadioGroup<String>(
                groupValue: languageCode,
                onChanged: _pickLanguage,
                child: Column(
                  children: [
                    RadioListTile<String>(
                      secondary: const Icon(Icons.language_rounded),
                      title: Text(l10n.settingsLanguageEnglish),
                      subtitle: languageCode == null
                          ? Text(l10n.settingsLanguageSubtitle)
                          : null,
                      value: 'en',
                    ),
                    const Divider(height: 1),
                    RadioListTile<String>(
                      secondary: const Icon(Icons.language_rounded),
                      title: Text(l10n.settingsLanguageNepali),
                      value: 'ne',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.settingsSectionSecurity,
                style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            // Availability is re-probed on build, so enrolling a fingerprint
            // later enables this without reinstalling the app.
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.fingerprint_rounded),
                title: Text(l10n.settingsBiometricLogin),
                subtitle: Text(
                  biometricsAvailable
                      ? l10n.settingsBiometricLoginSubtitle
                      : l10n.settingsBiometricUnavailable,
                ),
                value: _biometricEnabled && biometricsAvailable,
                // Disabled rather than hidden: the reason stays visible, so
                // the feature does not look missing.
                onChanged: biometricsAvailable ? _toggleBiometric : null,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.settingsSectionPreferences,
                style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined),
                title: Text(l10n.settingsScanReminders),
                subtitle: Text(l10n.settingsScanRemindersSubtitle),
                value: _scanReminders,
                onChanged: (enabled) async {
                  final notifications =
                      ref.read(localNotificationServiceProvider);
                  if (enabled) {
                    final granted = await notifications.requestPermission();
                    if (!granted) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.settingsNotificationPermissionRequired,
                            ),
                          ),
                        );
                      }
                      return;
                    }
                    await notifications.scheduleDailyReminder();
                  } else {
                    await notifications.cancelReminder();
                  }
                  await ref
                      .read(preferencesServiceProvider)
                      .setScanRemindersEnabled(enabled);
                  if (mounted) setState(() => _scanReminders = enabled);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.settingsSectionMembership,
                style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium_rounded),
                title: Text(l10n.settingsPremiumTitle),
                subtitle: Text(l10n.settingsPremiumSubtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(RoutePaths.premium),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.settingsSectionAbout, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: ListTile(
                leading: const Icon(Icons.spa_rounded),
                title: const Text('Healthify'),
                subtitle: Text(
                  version == null
                      ? l10n.settingsAboutTagline
                      : l10n.settingsAboutVersion(version),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
