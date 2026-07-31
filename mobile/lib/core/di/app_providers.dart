import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';

/// Central dependency-injection wiring. Riverpod providers are the DI
/// container: infrastructure singletons live here, feature repositories
/// declare their own providers next to their implementations.

/// Overridden in [main] with the real instance before the app starts.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  ),
);

/// The API origin for this build. Resolved once during startup (it needs an
/// async platform probe to tell an Android emulator from a real device) and
/// overridden here, so the rest of the app can read it synchronously.
final apiBaseUrlProvider = Provider<String>(
  (ref) => throw UnimplementedError(
    'apiBaseUrlProvider must be overridden in main()',
  ),
);

final preferencesServiceProvider = Provider<PreferencesService>(
  (ref) => PreferencesService(ref.watch(sharedPreferencesProvider)),
);

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(FlutterSecureStorage()),
);

/// Emits `true` while the device has any network transport available.
///
/// `onConnectivityChanged` only fires on a *change*, so it is seeded with the
/// current state — otherwise the app has no connectivity reading at all until
/// the network happens to change.
///
/// This reports the transport only (Wi-Fi/mobile present), not whether the
/// internet or the API is actually reachable. Request failures are the source
/// of truth for that, which is why it never gates requests.
final connectivityStatusProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool hasTransport(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  try {
    yield hasTransport(await connectivity.checkConnectivity());
  } catch (_) {
    // Never let a probe failure look like "offline".
    yield true;
  }
  yield* connectivity.onConnectivityChanged.map(hasTransport);
});

/// Reads the shipped bundle version so the UI can never drift from pubspec.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version}+${info.buildNumber}';
});
