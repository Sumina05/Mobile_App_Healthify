import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'api_endpoints.dart';

/// Where the API lives for the current build target.
///
/// The one case that cannot be guessed is a **physical Android device**: it
/// has no route to the dev machine's loopback, and its address on the LAN is
/// specific to the network it is on. That build must supply
/// `--dart-define=HEALTHIFY_API_BASE_URL=...`; [isMisconfigured] reports when
/// it did not, so startup can say so loudly instead of timing out silently.
@immutable
class ApiBaseUrl {
  const ApiBaseUrl({required this.value, required this.isMisconfigured});

  final String value;
  final bool isMisconfigured;
}

/// Pure resolution, kept free of platform channels so it is directly testable.
///
/// Order of precedence:
/// 1. an explicit `--dart-define` override — always wins;
/// 2. release builds — the production API;
/// 3. the Android **emulator** — 10.0.2.2 maps to the host's loopback;
/// 4. everything else (iOS simulator, desktop, web) — localhost.
ApiBaseUrl resolveApiBaseUrl({
  required bool isReleaseMode,
  required bool isWeb,
  required TargetPlatform platform,
  required bool isPhysicalDevice,
  String override = ApiEndpoints.baseUrlOverride,
}) {
  if (override.isNotEmpty) {
    return ApiBaseUrl(value: override, isMisconfigured: false);
  }
  if (isReleaseMode) {
    return const ApiBaseUrl(
      value: ApiEndpoints.productionBaseUrl,
      isMisconfigured: false,
    );
  }

  final isAndroid = !isWeb && platform == TargetPlatform.android;
  if (isAndroid && !isPhysicalDevice) {
    return const ApiBaseUrl(
      value: ApiEndpoints.androidEmulatorBaseUrl,
      isMisconfigured: false,
    );
  }

  return ApiBaseUrl(
    value: ApiEndpoints.localhostBaseUrl,
    // A real phone cannot reach the host's localhost — this build needs the
    // dart-define and will otherwise time out on every request.
    isMisconfigured: isAndroid && isPhysicalDevice,
  );
}

/// Reads the platform, then resolves. Called once during startup.
Future<ApiBaseUrl> detectApiBaseUrl() async {
  var isPhysicalDevice = true;
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      isPhysicalDevice = info.isPhysicalDevice;
    } catch (_) {
      // If the probe fails, assume an emulator so local development keeps
      // working; an explicit override still takes precedence.
      isPhysicalDevice = false;
    }
  }

  final resolved = resolveApiBaseUrl(
    isReleaseMode: kReleaseMode,
    isWeb: kIsWeb,
    platform: defaultTargetPlatform,
    isPhysicalDevice: isPhysicalDevice,
  );

  if (resolved.isMisconfigured) {
    debugPrint(
      '─────────────────────────────────────────────────────────────\n'
      'Healthify: running on a PHYSICAL Android device with no API\n'
      'base URL configured, so requests will time out.\n'
      '\n'
      'Re-run with your machine\'s LAN address, for example:\n'
      '  flutter run --dart-define=HEALTHIFY_API_BASE_URL='
      'http://192.168.1.10:5000/api/v1\n'
      '\n'
      'The backend prints its LAN address on startup.\n'
      'Falling back to ${resolved.value} (will not work on a phone).\n'
      '─────────────────────────────────────────────────────────────',
    );
  }
  return resolved;
}
