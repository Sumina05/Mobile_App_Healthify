import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive app preferences (theme, onboarding flags, reminders).
class PreferencesService {
  const PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String _themeModeKey = 'settings.themeMode';
  static const String _onboardingSeenKey = 'onboarding.seen';
  static const String _biometricEnabledKey = 'settings.biometricEnabled';
  static const String _scanRemindersKey = 'settings.scanReminders';
  static const String _languageCodeKey = 'settings.languageCode';

  ThemeMode get themeMode {
    final stored = _prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.dark,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_themeModeKey, mode.name);

  /// Null means "follow the device locale" — [supportedLanguageCodes]
  /// resolves that to English or Nepali at the point of use.
  static const List<String> supportedLanguageCodes = ['en', 'ne'];

  String? get languageCode {
    final stored = _prefs.getString(_languageCodeKey);
    return supportedLanguageCodes.contains(stored) ? stored : null;
  }

  Future<void> setLanguageCode(String? code) {
    if (code == null) return _prefs.remove(_languageCodeKey);
    return _prefs.setString(_languageCodeKey, code);
  }

  bool get hasSeenOnboarding => _prefs.getBool(_onboardingSeenKey) ?? false;

  Future<void> setOnboardingSeen() => _prefs.setBool(_onboardingSeenKey, true);

  bool get biometricEnabled => _prefs.getBool(_biometricEnabledKey) ?? false;

  Future<void> setBiometricEnabled(bool enabled) =>
      _prefs.setBool(_biometricEnabledKey, enabled);

  bool get scanRemindersEnabled => _prefs.getBool(_scanRemindersKey) ?? true;

  Future<void> setScanRemindersEnabled(bool enabled) =>
      _prefs.setBool(_scanRemindersKey, enabled);

  static const String _searchHistoryKey = 'search.history';
  static const int _searchHistoryLimit = 8;

  List<String> get searchHistory =>
      _prefs.getStringList(_searchHistoryKey) ?? const [];

  /// Most-recent-first, de-duplicated, capped at [_searchHistoryLimit].
  Future<void> addSearchTerm(String term) {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return Future.value();
    final history = [
      trimmed,
      ...searchHistory.where(
        (t) => t.toLowerCase() != trimmed.toLowerCase(),
      ),
    ].take(_searchHistoryLimit).toList();
    return _prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() => _prefs.remove(_searchHistoryKey);
}
