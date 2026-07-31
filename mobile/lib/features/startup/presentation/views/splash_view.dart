import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/status_view.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final startup = ref.watch(splashViewModelProvider);

    if (startup.hasError && !startup.isLoading) {
      final error = startup.error;
      return Scaffold(
        body: SafeArea(
          child: StatusView.offline(
            message: error is AppException
                ? error.message
                : 'Could not reach Healthify. Check your connection.',
            onRetry: () => ref.read(splashViewModelProvider.notifier).retry(),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.darkHero),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1),
                duration: AppDurations.slow,
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: AppGradients.primary,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: AppGradients.primaryGlow,
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    size: 48,
                    color: AppColors.onMint,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Healthify',
                style: theme.textTheme.displaySmall
                    ?.copyWith(color: AppColors.darkTextPrimary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'AI-powered skincare that understands you.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.darkTextSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              const AppLoader(size: 28),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
