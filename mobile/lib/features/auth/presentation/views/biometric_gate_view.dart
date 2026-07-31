import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/biometric_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../viewmodels/auth_controller.dart';

/// "Unlock Healthify" — shown when a session exists and biometric login
/// is enabled. Auto-prompts once, with manual retry and password fallback.
class BiometricGateView extends ConsumerStatefulWidget {
  const BiometricGateView({super.key});

  @override
  ConsumerState<BiometricGateView> createState() => _BiometricGateViewState();
}

class _BiometricGateViewState extends ConsumerState<BiometricGateView> {
  bool _unlocking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (_unlocking) return;
    setState(() => _unlocking = true);
    final ok = await ref.read(biometricServiceProvider).authenticate();
    if (!mounted) return;
    if (ok) {
      await ref.read(authControllerProvider.notifier).completeUnlock();
    } else {
      setState(() => _unlocking = false);
    }
  }

  void _usePassword() {
    // Keeps the stored session and biometric preference; the user simply
    // signs in with credentials instead this time.
    ref.read(authControllerProvider.notifier).sessionExpired();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.darkHero),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                Text(
                  'Unlock Healthify',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: AppColors.darkTextPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Use biometrics to login quickly and securely.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.darkTextSecondary),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mint, width: 2),
                      boxShadow: AppGradients.primaryGlow,
                    ),
                    child: const Icon(
                      Icons.fingerprint_rounded,
                      size: 72,
                      color: AppColors.mint,
                    ),
                  ),
                ),
                const Spacer(),
                GradientButton(
                  label: _unlocking ? 'Waiting for biometrics…' : 'Unlock',
                  icon: Icons.fingerprint_rounded,
                  isLoading: _unlocking,
                  onPressed: _unlock,
                ),
                TextButton(
                  onPressed: _usePassword,
                  child: const Text('Use Password Instead'),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
