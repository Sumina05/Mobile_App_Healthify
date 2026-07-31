import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_spacing.dart';

/// Primary CTA with the Healthify gradient, glow, and loading state.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient = AppGradients.primary,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final bool isLoading;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(fontSize: 16, color: AppColors.onMint);

    return Semantics(
      button: true,
      enabled: _enabled,
      // While loading the label is replaced by a spinner, so state it here
      // or the control becomes unlabelled to a screen reader.
      label: isLoading ? '$label, in progress' : label,
      // excludeSemantics hides the inner InkWell, which owns the tap action
      // and focusability, so both are re-declared here or the button becomes
      // unactivatable and unreachable by keyboard/switch navigation.
      onTap: _enabled ? _handleTap : null,
      focusable: _enabled,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: AppDurations.fast,
        opacity: _enabled ? 1 : 0.55,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: _enabled ? AppGradients.primaryGlow : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _enabled ? _handleTap : null,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                height: 52,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.onMint,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, size: 20, color: AppColors.onMint),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            Text(label, style: textStyle),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Every primary action in the app is a [GradientButton], so this is the
  /// one place tactile feedback needs to live.
  void _handleTap() {
    HapticFeedback.lightImpact();
    onPressed!.call();
  }
}
