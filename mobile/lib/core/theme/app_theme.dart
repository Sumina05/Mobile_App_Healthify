import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Material 3 theme pair for Healthify. Dark is the primary experience.
abstract final class AppTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.mint,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.mint,
      onPrimary: AppColors.onMint,
      secondary: AppColors.cyan,
      onSecondary: AppColors.onMint,
      tertiary: AppColors.violet,
      onTertiary: Colors.white,
      error: AppColors.danger,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      surfaceContainerLowest: AppColors.darkBackground,
      surfaceContainerLow: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurfaceHigh,
      surfaceContainerHigh: AppColors.darkSurfaceHighest,
      surfaceContainerHighest: AppColors.darkSurfaceHighest,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutline,
    );
    return _base(
      scheme: scheme,
      background: AppColors.darkBackground,
      fieldFill: AppColors.darkSurfaceHigh,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      systemOverlay: SystemUiOverlayStyle.light,
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.mint,
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF0EA97C),
      onPrimary: Colors.white,
      secondary: const Color(0xFF0891B2),
      onSecondary: Colors.white,
      tertiary: AppColors.violet,
      onTertiary: Colors.white,
      error: const Color(0xFFDC2626),
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      surfaceContainerLowest: AppColors.lightBackground,
      surfaceContainerLow: AppColors.lightSurface,
      surfaceContainer: AppColors.lightSurfaceHigh,
      surfaceContainerHigh: AppColors.lightSurfaceHighest,
      surfaceContainerHighest: AppColors.lightSurfaceHighest,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutline,
    );
    return _base(
      scheme: scheme,
      background: AppColors.lightBackground,
      fieldFill: AppColors.lightSurfaceHigh,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      systemOverlay: SystemUiOverlayStyle.dark,
    );
  }

  static ThemeData _base({
    required ColorScheme scheme,
    required Color background,
    required Color fieldFill,
    required Color textPrimary,
    required Color textSecondary,
    required SystemUiOverlayStyle systemOverlay,
  }) {
    final textTheme = AppTypography.textTheme(
      primary: textPrimary,
      secondary: textSecondary,
    );

    OutlineInputBorder fieldBorder(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: systemOverlay,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainer,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        hintStyle: textTheme.bodyMedium,
        labelStyle: textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.base,
        ),
        border: fieldBorder(Colors.transparent),
        enabledBorder: fieldBorder(Colors.transparent),
        focusedBorder: fieldBorder(scheme.primary, width: 1.5),
        errorBorder: fieldBorder(scheme.error),
        focusedErrorBorder: fieldBorder(scheme.error, width: 1.5),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(
            color: states.contains(WidgetState.selected)
                ? scheme.primary
                : textSecondary,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primary.withValues(alpha: 0.16),
        labelStyle: textTheme.labelMedium!.copyWith(color: textPrimary),
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.surfaceContainerHigh,
        contentTextStyle: textTheme.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainer,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
