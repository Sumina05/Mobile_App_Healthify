import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/network/api_base_url.dart';
import 'package:healthify_mobile/core/network/api_endpoints.dart';

ApiBaseUrl resolve({
  bool isReleaseMode = false,
  bool isWeb = false,
  TargetPlatform platform = TargetPlatform.android,
  bool isPhysicalDevice = false,
  String override = '',
}) =>
    resolveApiBaseUrl(
      isReleaseMode: isReleaseMode,
      isWeb: isWeb,
      platform: platform,
      isPhysicalDevice: isPhysicalDevice,
      override: override,
    );

void main() {
  group('Android', () {
    test('emulator uses the 10.0.2.2 host alias', () {
      final result = resolve(isPhysicalDevice: false);
      expect(result.value, ApiEndpoints.androidEmulatorBaseUrl);
      expect(result.value, contains('10.0.2.2'));
      expect(result.isMisconfigured, isFalse);
    });

    test('a physical device never uses 10.0.2.2', () {
      // The original bug: every Android target got the emulator alias, so
      // requests from a real phone timed out.
      final result = resolve(isPhysicalDevice: true);
      expect(result.value, isNot(contains('10.0.2.2')));
    });

    test('a physical device without an override is flagged as misconfigured',
        () {
      expect(resolve(isPhysicalDevice: true).isMisconfigured, isTrue);
    });

    test('a physical device with an override is correctly configured', () {
      final result = resolve(
        isPhysicalDevice: true,
        override: 'http://192.168.1.10:5000/api/v1',
      );
      expect(result.value, 'http://192.168.1.10:5000/api/v1');
      expect(result.isMisconfigured, isFalse);
    });

    test('an override wins over the emulator alias', () {
      final result = resolve(
        isPhysicalDevice: false,
        override: 'http://192.168.1.10:5000/api/v1',
      );
      expect(result.value, 'http://192.168.1.10:5000/api/v1');
    });
  });

  group('other targets', () {
    test('iOS simulator uses localhost', () {
      final result = resolve(
        platform: TargetPlatform.iOS,
        isPhysicalDevice: false,
      );
      expect(result.value, ApiEndpoints.localhostBaseUrl);
      expect(result.isMisconfigured, isFalse);
    });

    test('a physical iPhone is not flagged — only Android is special-cased',
        () {
      // 10.0.2.2 is an Android-emulator concept; iOS has no equivalent, so a
      // physical iPhone is treated like any other non-emulator target.
      final result = resolve(
        platform: TargetPlatform.iOS,
        isPhysicalDevice: true,
      );
      expect(result.value, ApiEndpoints.localhostBaseUrl);
      expect(result.isMisconfigured, isFalse);
    });

    test('desktop uses localhost', () {
      expect(
        resolve(platform: TargetPlatform.macOS).value,
        ApiEndpoints.localhostBaseUrl,
      );
    });

    test('web uses localhost even when the platform reports Android', () {
      final result = resolve(isWeb: true, isPhysicalDevice: false);
      expect(result.value, ApiEndpoints.localhostBaseUrl);
    });
  });

  group('release builds', () {
    test('use the production API regardless of device', () {
      expect(
        resolve(isReleaseMode: true, isPhysicalDevice: true).value,
        ApiEndpoints.productionBaseUrl,
      );
      expect(
        resolve(isReleaseMode: true, isPhysicalDevice: false).value,
        ApiEndpoints.productionBaseUrl,
      );
    });

    test('are never flagged as misconfigured', () {
      expect(
        resolve(isReleaseMode: true, isPhysicalDevice: true).isMisconfigured,
        isFalse,
      );
    });

    test('still honour an explicit override, for staging builds', () {
      final result = resolve(
        isReleaseMode: true,
        override: 'https://staging.healthify.app/api/v1',
      );
      expect(result.value, 'https://staging.healthify.app/api/v1');
    });
  });

  test('every resolved URL is absolute and carries the /api/v1 prefix', () {
    for (final result in [
      resolve(isPhysicalDevice: false),
      resolve(platform: TargetPlatform.iOS),
      resolve(isReleaseMode: true),
    ]) {
      final uri = Uri.parse(result.value);
      expect(uri.hasScheme, isTrue, reason: '${result.value} needs a scheme');
      expect(uri.host, isNotEmpty);
      expect(result.value, endsWith('/api/v1'));
      // Guards against the doubled-scheme regression fixed earlier.
      expect('://'.allMatches(result.value).length, 1);
    }
  });
}
