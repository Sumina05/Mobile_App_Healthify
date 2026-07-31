import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

/// Thin wrapper over local_auth so features and tests never touch the
/// plugin directly.
class BiometricService {
  BiometricService([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<bool> isSupported() async {
    try {
      return await _auth.isDeviceSupported() &&
          await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  Future<bool> authenticate({
    String reason = 'Unlock Healthify quickly and securely',
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    }
  }
}

final biometricServiceProvider =
    Provider<BiometricService>((ref) => BiometricService());

/// Whether this device can actually do biometric authentication.
///
/// Hardware and enrolment can both change while the app is installed (a user
/// enrols a fingerprint later, or removes the only one), so this is a provider
/// rather than a one-off startup read: `ref.invalidate` re-probes and every
/// dependent screen updates. Errors resolve to `false` — an unavailable
/// sensor must never surface as an error state.
final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  try {
    return await ref.watch(biometricServiceProvider).isSupported();
  } catch (_) {
    return false;
  }
});
