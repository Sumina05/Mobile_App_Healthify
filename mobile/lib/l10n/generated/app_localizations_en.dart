// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageNepali => 'नेपाली';

  @override
  String get settingsLanguageSubtitle =>
      'Choose the language used throughout the app';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsBiometricLogin => 'Biometric Login';

  @override
  String get settingsBiometricLoginSubtitle =>
      'Unlock Healthify with fingerprint or face';

  @override
  String get settingsBiometricUnavailable =>
      'Biometric authentication is not available on this device. Email and password login works as normal.';

  @override
  String get settingsBiometricNotSupportedSnackbar =>
      'Biometric authentication is not available on this device';

  @override
  String get settingsSectionPreferences => 'Preferences';

  @override
  String get settingsScanReminders => 'Scan Reminders';

  @override
  String get settingsScanRemindersSubtitle =>
      'A daily nudge to analyze products';

  @override
  String get settingsNotificationPermissionRequired =>
      'Notification permission is required for reminders';

  @override
  String get settingsSectionMembership => 'Membership';

  @override
  String get settingsPremiumTitle => 'Healthify Premium';

  @override
  String get settingsPremiumSubtitle => 'Plans, payment, and benefits';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsAboutTagline => 'AI-powered skincare ingredient analysis';

  @override
  String settingsAboutVersion(String version) {
    return 'AI-powered skincare ingredient analysis · v$version';
  }

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try Again';

  @override
  String get commonLogin => 'Login';

  @override
  String get commonLogout => 'Log Out';
}
