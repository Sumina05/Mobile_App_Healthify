import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared gradients and glows that give Healthify its premium look.
abstract final class AppGradients {
  /// Primary CTA — mint to cyan (Get Started, Scan, score rings).
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.mint, AppColors.cyan],
  );

  /// Secondary CTA — violet to indigo (Login, premium surfaces).
  static const LinearGradient accent = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.violet, AppColors.indigo],
  );

  /// Subtle sheen used behind hero sections on dark screens.
  static const LinearGradient darkHero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0E1E22), AppColors.darkBackground],
  );

  /// Frosted-glass card fill (pair with a blur + hairline border).
  static const LinearGradient glassDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x14FFFFFF), Color(0x05FFFFFF)],
  );

  static const LinearGradient glassLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xB3FFFFFF), Color(0x66FFFFFF)],
  );

  /// Soft glow behind primary gradient buttons.
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: AppColors.mint.withValues(alpha: 0.35),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> accentGlow = [
    BoxShadow(
      color: AppColors.indigo.withValues(alpha: 0.35),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
