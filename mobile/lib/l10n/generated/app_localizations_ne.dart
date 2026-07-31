// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get settingsTitle => 'सेटिङहरू';

  @override
  String get settingsSectionAppearance => 'रूपरेखा';

  @override
  String get settingsDarkMode => 'डार्क मोड';

  @override
  String get settingsSectionLanguage => 'भाषा';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageNepali => 'नेपाली';

  @override
  String get settingsLanguageSubtitle =>
      'पूरै एपमा प्रयोग हुने भाषा छान्नुहोस्';

  @override
  String get settingsSectionSecurity => 'सुरक्षा';

  @override
  String get settingsBiometricLogin => 'बायोमेट्रिक लगइन';

  @override
  String get settingsBiometricLoginSubtitle =>
      'फिंगरप्रिन्ट वा अनुहारद्वारा Healthify अनलक गर्नुहोस्';

  @override
  String get settingsBiometricUnavailable =>
      'यो यन्त्रमा बायोमेट्रिक प्रमाणीकरण उपलब्ध छैन। इमेल र पासवर्डबाट लगइन सामान्य रूपमा काम गर्छ।';

  @override
  String get settingsBiometricNotSupportedSnackbar =>
      'यो यन्त्रमा बायोमेट्रिक प्रमाणीकरण उपलब्ध छैन';

  @override
  String get settingsSectionPreferences => 'प्राथमिकताहरू';

  @override
  String get settingsScanReminders => 'स्क्यान रिमाइन्डर';

  @override
  String get settingsScanRemindersSubtitle =>
      'उत्पादनहरू विश्लेषण गर्न दैनिक सम्झना';

  @override
  String get settingsNotificationPermissionRequired =>
      'रिमाइन्डरका लागि सूचना अनुमति आवश्यक छ';

  @override
  String get settingsSectionMembership => 'सदस्यता';

  @override
  String get settingsPremiumTitle => 'Healthify प्रिमियम';

  @override
  String get settingsPremiumSubtitle => 'योजना, भुक्तानी, र सुविधाहरू';

  @override
  String get settingsSectionAbout => 'बारेमा';

  @override
  String get settingsAboutTagline => 'AI-संचालित स्किनकेयर सामग्री विश्लेषण';

  @override
  String settingsAboutVersion(String version) {
    return 'AI-संचालित स्किनकेयर सामग्री विश्लेषण · v$version';
  }

  @override
  String get commonSave => 'सुरक्षित गर्नुहोस्';

  @override
  String get commonCancel => 'रद्द गर्नुहोस्';

  @override
  String get commonRetry => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get commonLogin => 'लगइन';

  @override
  String get commonLogout => 'लगआउट';
}
