import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/di/app_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_button.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const _pages = [
  _OnboardingPage(
    icon: Icons.document_scanner_rounded,
    title: 'Scan Any Product\nIngredient List',
    body:
        'Use your camera or upload an image. We extract and analyze ingredients instantly with AI.',
  ),
  _OnboardingPage(
    icon: Icons.psychology_rounded,
    title: 'AI That Explains\nEvery Ingredient',
    body:
        'We break down complex ingredients into simple explanations — purpose, benefits, risks and safety info.',
  ),
  _OnboardingPage(
    icon: Icons.face_retouching_natural_rounded,
    title: 'Personalized\nJust For You',
    body:
        'Get product suitability scores and recommendations based on your unique skin profile.',
  ),
];

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(preferencesServiceProvider).setOnboardingSeen();
    if (mounted) context.go(RoutePaths.login);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.darkHero),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    final page = _pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            key: ValueKey(i),
                            tween: Tween(begin: 0.85, end: 1),
                            duration: AppDurations.slow,
                            curve: Curves.easeOutBack,
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: AppGradients.primary,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.xl),
                                boxShadow: AppGradients.primaryGlow,
                              ),
                              child: Icon(
                                page.icon,
                                size: 72,
                                color: AppColors.onMint,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(color: AppColors.darkTextPrimary),
                          ),
                          const SizedBox(height: AppSpacing.base),
                          Text(
                            page.body,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: AppColors.darkTextSecondary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: AppDurations.normal,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.mint
                          : AppColors.darkTextSecondary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: GradientButton(
                  label: isLast ? 'Get Started' : 'Next',
                  icon: isLast ? Icons.rocket_launch_rounded : null,
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
