import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/di/app_providers.dart';
import 'core/network/api_base_url.dart';
import 'core/services/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  // Needs a platform probe (emulator vs physical device), so it is resolved
  // once here rather than on every read.
  final apiBaseUrl = await detectApiBaseUrl();
  await LocalNotificationService().init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        apiBaseUrlProvider.overrideWithValue(apiBaseUrl.value),
      ],
      child: const HealthifyApp(),
    ),
  );
}
