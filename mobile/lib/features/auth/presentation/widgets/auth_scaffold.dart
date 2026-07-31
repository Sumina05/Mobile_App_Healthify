import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';

/// Shared layout for every auth screen.
///
/// The form sits on an elevated card rather than directly on the background:
/// it lifts the content off a very dark surface, gives the inputs room to
/// breathe, and reads as deliberate in both themes. The backdrop is a soft
/// two-tone wash rather than a flat near-black.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showBack = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // How much of the screen the keyboard is covering. Added to the scroll
    // padding so the form can always scroll clear of it — without this the
    // Login button and the sign-up link sit underneath the keyboard.
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    // Lifted well above the near-black scaffold colour.
                    const Color(0xFF12202F),
                    const Color(0xFF0B131E),
                    theme.scaffoldBackgroundColor,
                  ]
                : [
                    AppColors.mint.withValues(alpha: 0.10),
                    AppColors.cyan.withValues(alpha: 0.05),
                    theme.scaffoldBackgroundColor,
                  ],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: Stack(
          children: [
            // Soft brand glow behind the hero, keeps the top from going flat.
            Positioned(
              top: -120,
              right: -80,
              child: _Glow(color: AppColors.mint.withValues(alpha: 0.16)),
            ),
            Positioned(
              top: 40,
              left: -110,
              child: _Glow(color: AppColors.violet.withValues(alpha: 0.12)),
            ),
            // bottom:false because the keyboard inset is handled explicitly
            // below; letting SafeArea also pad the bottom double-counts it.
            SafeArea(
              bottom: false,
              child: _EntranceAnimation(
                child: SingleChildScrollView(
                  // Keeps the header clear of the status bar when the view
                  // scrolls to reveal a focused field.
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.base,
                    AppSpacing.screen,
                    AppSpacing.xl + keyboardInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showBack && context.canPop())
                        _BackButton(onTap: context.pop)
                      else
                        const SizedBox(height: AppSpacing.sm),
                      const SizedBox(height: AppSpacing.lg),
                      const _BrandMark(),
                      const SizedBox(height: AppSpacing.xl),
                      Text(title, style: theme.textTheme.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _FormCard(children: children),
                      const SizedBox(height: AppSpacing.lg),
                      const _TrustFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Healthify logo mark and wordmark, matching the splash screen so the
/// first two screens a user sees share one identity.
class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppGradients.primaryGlow,
          ),
          child: const Icon(
            Icons.spa_rounded,
            size: 30,
            color: AppColors.onMint,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Healthify',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Know what you put on your skin',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}

/// Elevated container holding the form. Uses a solid surface rather than a
/// blur so text contrast stays predictable in both themes.
class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Quiet reassurance under the form — the kind of line a health or banking
/// app carries, and cheap credibility for a screen asking for a password.
class _TrustFooter extends StatelessWidget {
  const _TrustFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            'Your data is encrypted and never sold',
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        tooltip: 'Back',
        style: IconButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainerHigh,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(AppSpacing.md),
        ),
      ),
    );
  }
}

/// Decorative blurred brand glow.
class _Glow extends StatelessWidget {
  const _Glow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}

/// One-shot fade + rise as the screen mounts.
class _EntranceAnimation extends StatefulWidget {
  const _EntranceAnimation({required this.child});

  final Widget child;

  @override
  State<_EntranceAnimation> createState() => _EntranceAnimationState();
}

class _EntranceAnimationState extends State<_EntranceAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.slow,
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Standard error listener: surfaces ViewModel failures as snackbars.
void showErrorSnackBar(BuildContext context, Object error) {
  final theme = Theme.of(context);
  // Typed failures carry a written-for-humans message; splitting toString()
  // mangled anything containing ": " (e.g. "status: unknown" → "unknown").
  final message = error is AppException
      ? error.message
      : 'Something went wrong. Please try again.';

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.danger, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(message, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
}
